-- RetailCore 10.2.7 world DB repairs
--
-- Follow-up to 2026_10_25_01_world.sql, found while verifying that patch: two groups of
-- rows still make the loader complain every start.
--
-- 1. gameobject.terrainSwapMap holds small negative ids (-2, -3, -4, -7, -30, -33, -302,
--    -429, ...) on 310 rows. terrainSwapMap is a map id, map ids are unsigned, so any
--    value below -1 can never resolve. ObjectMgr::LoadGameObjectSpawnData does the same
--    lookup as for creatures and rewrites them to -1 in memory, so storing -1 changes
--    nothing at runtime. creature has no such row, only gameobject.
--
-- 2. quest_poi has 59 rows whose (QuestID, Idx1) has no quest_poi_points row at all. The
--    loader reports "Table quest_poi references unknown quest points" for each. Such a
--    row has no point, so it can never show up on the map; it is dropped instead of
--    inventing coordinates.

UPDATE gameobject SET terrainSwapMap = -1 WHERE terrainSwapMap < -1;

DELETE qp FROM quest_poi qp
WHERE NOT EXISTS (SELECT 1 FROM quest_poi_points qpp WHERE qpp.QuestID = qp.QuestID AND qpp.Idx1 = qp.Idx1);
