-- Creature spawns for the missing cell of Old Hillsbrad Foothills (map 560).
-- Source: TDB_full_world_1027.24051_2024_05_11.sql (official TrinityCore TDB)
-- guids are taken from a reserved range, the DELETE keeps this file re-runnable.

DELETE FROM `creature` WHERE `guid` BETWEEN 910000000004000001 AND 910000000004000010;

INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(910000000004000001,2385,560,0,0,'1,2',0,0,0,-1,0,0,2046,-24.6693,59.9998,5.97807,300,3,0,100,1,NULL,NULL,NULL,NULL,'',NULL,0),
(910000000004000002,2354,560,0,0,'1,2',0,0,0,-1,0,0,2113.42,-25.3041,66.8198,0.286286,300,3,0,100,1,NULL,NULL,NULL,NULL,'',NULL,0),
(910000000004000003,2385,560,0,0,'1,2',0,0,0,-1,0,0,2207.7,-81.5329,83.0974,5.4542,300,3,0,100,1,NULL,NULL,NULL,NULL,'',NULL,0),
(910000000004000004,2385,560,0,0,'1,2',0,0,0,-1,0,0,2211.75,-107.583,86.3452,4.27846,300,3,0,100,1,NULL,NULL,NULL,NULL,'',NULL,0),
(910000000004000005,2385,560,0,0,'1,2',0,0,0,-1,0,0,2175.9,-211.096,69.1768,1.7212,300,3,0,100,1,NULL,NULL,NULL,NULL,'',NULL,0),
(910000000004000006,2354,560,0,0,'1,2',0,0,0,-1,0,0,2243.16,-86.5874,86.8439,0.545463,300,3,0,100,1,NULL,NULL,NULL,NULL,'',NULL,0),
(910000000004000007,2385,560,0,0,'1,2',0,0,0,-1,0,0,2279.52,-64.5863,87.5276,0.545463,300,3,0,100,1,NULL,NULL,NULL,NULL,'',NULL,0),
(910000000004000008,2350,560,0,0,'1,2',0,0,0,-1,0,0,2343.91,-57.5838,89.1852,0.545463,300,3,0,100,1,NULL,NULL,NULL,NULL,'',NULL,0),
(910000000004000009,2354,560,0,0,'1,2',0,0,0,-1,0,0,2376.99,-32.7886,95.1279,2.70766,300,3,0,100,1,NULL,NULL,NULL,NULL,'',NULL,0),
(910000000004000010,2354,560,0,0,'1,2',0,0,0,-1,0,0,2003.23,-57.4405,56.9819,2.4634,300,3,0,100,1,NULL,NULL,NULL,NULL,'',NULL,0);
