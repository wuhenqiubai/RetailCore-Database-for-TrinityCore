-- creature_queststarter / creature_questender: drop duplicated quest relations.
--
-- Both tables use PRIMARY KEY (id, quest, VerifiedBuild), so one (id, quest)
-- pair can be stored twice: once with VerifiedBuild = 0 (the placeholder a bulk
-- importer leaves behind) and once with the real client build. The loader
-- (ObjectMgr::LoadQuestRelationsHelper) inserts every row into a multimap, so
-- the duplicate survives into memory and the npcflag sanity check reports the
-- same giver twice.
--
-- Surveyed on this world database: 1379 duplicated (id, quest) pairs in
-- creature_queststarter and 1427 in creature_questender, every group holding
-- exactly two rows, and in all groups the lowest VerifiedBuild is 0. Keeping the
-- highest build therefore deletes exactly one row per group (2806 rows total)
-- and never removes the only copy of a relation.
--
-- Idempotent: after the first run no group has a lower build left, so the join
-- matches nothing.

DELETE qs FROM creature_queststarter qs
INNER JOIN
(
    SELECT id, quest, MAX(VerifiedBuild) AS keep_build
    FROM creature_queststarter
    GROUP BY id, quest
    HAVING COUNT(*) > 1
) dup ON dup.id = qs.id AND dup.quest = qs.quest
WHERE qs.VerifiedBuild < dup.keep_build;

DELETE qe FROM creature_questender qe
INNER JOIN
(
    SELECT id, quest, MAX(VerifiedBuild) AS keep_build
    FROM creature_questender
    GROUP BY id, quest
    HAVING COUNT(*) > 1
) dup ON dup.id = qe.id AND dup.quest = qe.quest
WHERE qe.VerifiedBuild < dup.keep_build;
