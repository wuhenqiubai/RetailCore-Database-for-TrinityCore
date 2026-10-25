-- Dangling references reported by the world server at load time: loot ids,
-- SmartAI links, orphan rows and spawn bookkeeping.
--
-- These are the load time messages of type "Table 'x' Entry N does not exist but
-- it is used by Creature N", "SmartAIMgr::LoadSmartAIFromDB: Entry N SourceType
-- N, Event N, Link Event N not found or invalid", "Creature (GUID: N) does not
-- exist but has a record in `creature_addon`" and friends. In every case the
-- referenced row is missing, so the reference can never resolve and the server
-- only spends time reporting it. Nothing that still resolves is touched.
--
-- Sections 4, 5 and 6 delete rows that have no owner left (their parent spawn or
-- template is gone) - they are unreachable for the loader as well.
--
-- Surveyed on this world database (TDB 1027.24051, 2026-10-25):
--   section 1: creature_template_difficulty LootID 272887, PickPocketLootID 7512,
--              SkinLootID 9950 dangling references
--   section 3: 153836 rows whose link points at a missing (or non LINK) event
--   section 4: creature_template_model 8279, creature_addon 6341,
--              creature_template_difficulty 2722, gameobject_addon 2163 orphans
--   section 5: quest_poi 5093 rows whose quest no longer exists
--   section 6: spawn_group 3223 creature and 57 gameobject members gone
--   section 7: creature 3253 and gameobject 150 rows with terrainSwapMap 0
--
-- ============================================================================
-- INCIDENT NOTICE - sections 1 and 3 were partially applied already
-- ============================================================================
-- On 2026-10-25 a read only rehearsal of these two statements was started
-- without START TRANSACTION. The client ran with autocommit = 1, so both
-- statements committed instead of rolling back. Affected rows in the local test
-- database world:
--   * creature_template_difficulty: LootID 0 on 272887 rows (LootID <> 0 is now
--     58174 rows), PickPocketLootID on 7512, SkinLootID on 9950
--   * smart_scripts: link 0 on 153819 rows (5588 rows keep a non zero link:
--     5571 of them resolve, 17 cannot be normalised, see below)
-- The change is behaviourally equivalent to the intended one (a dangling
-- reference already returned nothing from LootMgr and FindLinkedEvent), the
-- database state was verified self consistent afterwards (0 dangling loot ids,
-- 17 link rows left over) and a dump of both tables was taken before the
-- cleanup continued. Sections 4 to 7 were then measured inside a transaction and
-- rolled back; they have not been applied.
-- Consequence: this file is idempotent, it applies cleanly on a fresh TDB and is
-- a no-op on a database where sections 1 and 3 already ran.
--
-- 17 smart_scripts rows keep a dangling link on purpose: their (entryorguid,
-- source_type, id) key already has a row with link = 0, and link is part of the
-- primary key, so setting the dangling row to 0 would insert a duplicate. A
-- dangling link only suppresses the chained event (SmartScript::ProcessAction
-- logs it and moves on), so leaving those rows alone is equivalent to clearing
-- them. They account for 17 of the current messages per startup.
--
-- Idempotent: every statement is state based, it only matches rows whose
-- reference is still dangling, so a second run changes nothing.

-- 1. creature_template_difficulty: loot ids that no loot table defines.
--    LootMgr::ReportNonExistingId already returns nothing for those, so the
--    columns are set to 0 which is what an unset loot id means.

UPDATE creature_template_difficulty ctd
LEFT JOIN
(
    SELECT DISTINCT Entry
    FROM creature_loot_template
) clt ON clt.Entry = ctd.LootID
SET ctd.LootID = 0
WHERE ctd.LootID <> 0 AND clt.Entry IS NULL;

UPDATE creature_template_difficulty ctd
LEFT JOIN
(
    SELECT DISTINCT Entry
    FROM pickpocketing_loot_template
) plt ON plt.Entry = ctd.PickPocketLootID
SET ctd.PickPocketLootID = 0
WHERE ctd.PickPocketLootID <> 0 AND plt.Entry IS NULL;

UPDATE creature_template_difficulty ctd
LEFT JOIN
(
    SELECT DISTINCT Entry
    FROM skinning_loot_template
) slt ON slt.Entry = ctd.SkinLootID
SET ctd.SkinLootID = 0
WHERE ctd.SkinLootID <> 0 AND slt.Entry IS NULL;

-- 3. smart_scripts: links that can never fire.
--    SmartAIMgr::FindLinkedEvent only accepts a row of the same script group
--    whose id equals link and whose event_type is 61 (SMART_EVENT_LINK). Any
--    other link is dropped at runtime, so it is set to 0.
--    Only the lowest dangling link of a key is rewritten: link is part of the
--    primary key, so normalising several rows of one key at once could collide
--    with an existing link = 0 row.

UPDATE smart_scripts s
LEFT JOIN
(
    SELECT DISTINCT entryorguid, source_type, id
    FROM smart_scripts
    WHERE event_type = 61
) tgt ON tgt.entryorguid = s.entryorguid AND tgt.source_type = s.source_type AND tgt.id = s.link
LEFT JOIN
(
    SELECT DISTINCT entryorguid, source_type, id
    FROM smart_scripts
    WHERE link = 0
) zero ON zero.entryorguid = s.entryorguid AND zero.source_type = s.source_type AND zero.id = s.id
LEFT JOIN
(
    SELECT entryorguid, source_type, id, MIN(link) AS keep_link
    FROM smart_scripts
    WHERE link <> 0
    GROUP BY entryorguid, source_type, id
) low ON low.entryorguid = s.entryorguid AND low.source_type = s.source_type AND low.id = s.id
SET s.link = 0
WHERE s.link <> 0
    AND tgt.id IS NULL
    AND zero.id IS NULL
    AND s.link = low.keep_link;

-- 4. Orphan rows: the parent creature / template is gone, nothing can load them.

DELETE ctm FROM creature_template_model ctm
LEFT JOIN creature_template ct ON ct.entry = ctm.CreatureID
WHERE ct.entry IS NULL;

DELETE ca FROM creature_addon ca
LEFT JOIN creature c ON c.guid = ca.guid
WHERE c.guid IS NULL;

DELETE ctd FROM creature_template_difficulty ctd
LEFT JOIN creature_template ct ON ct.entry = ctd.Entry
WHERE ct.entry IS NULL;

DELETE ga FROM gameobject_addon ga
LEFT JOIN gameobject go ON go.guid = ga.guid
WHERE go.guid IS NULL;

-- 5. quest_poi: points of interest of quests that do not exist.

-- 5a. quest_poi_points are keyed by (QuestID, Idx1) and are meaningless without their
--     quest_poi row, so they are removed first (also covers points that had no poi row).
DELETE qpp FROM quest_poi_points qpp
WHERE NOT EXISTS (SELECT 1 FROM quest_template qt WHERE qt.ID = qpp.QuestID);

DELETE qp FROM quest_poi qp
LEFT JOIN quest_template qt ON qt.ID = qp.QuestID
WHERE qt.ID IS NULL;

DELETE qpp FROM quest_poi_points qpp
WHERE NOT EXISTS (SELECT 1 FROM quest_poi qp WHERE qp.QuestID = qpp.QuestID AND qp.Idx1 = qpp.Idx1);

-- 6. spawn_group: members whose spawn row is gone. ObjectMgr::LoadSpawnGroups
--    reports them and drops the member, the group itself is kept.

DELETE sg FROM spawn_group sg
WHERE sg.spawnType = 0 AND NOT EXISTS (SELECT 1 FROM creature c WHERE c.guid = sg.spawnId);

DELETE sg FROM spawn_group sg
WHERE sg.spawnType = 1 AND NOT EXISTS (SELECT 1 FROM gameobject g WHERE g.guid = sg.spawnId);

-- 7. terrainSwapMap 0 means "not set", but ObjectMgr::LoadCreatureSpawnData
--    (ObjectMgr.cpp:2326-2339) treats any value other than -1 as a real map id:
--    it looks the id up, then requires MapEntry::ParentMapID == the spawn's map.
--    Map 0 exists and its ParentMapID is -1, which no spawn map equals, so every
--    terrainSwapMap = 0 row is reported and rewritten to -1 in memory at load.
--    Storing -1 writes back exactly what the loader already uses.

UPDATE creature SET terrainSwapMap = -1 WHERE terrainSwapMap = 0;

UPDATE gameobject SET terrainSwapMap = -1 WHERE terrainSwapMap = 0;
