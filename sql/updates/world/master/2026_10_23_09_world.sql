-- Clear unknown PhaseIds from creature and gameobject spawns.
--
-- These spawns reference phase ids that are missing from the phase store, i.e. from both the
-- client's Phase.db2 (20349 ids) and `hotfixes`.`phase` (2332 ids). PhasingHandler cannot grant
-- such a phase to any player, so every one of these spawns is permanently invisible.
--
-- The phase ids 9007-21434 are additionally removed from `phase_area` by
-- 2026_10_23_08_world.sql, which makes them fully orphaned. 1, 7, 403, 8186, 40445, 49405,
-- 54958 and 66565 never had a `phase_area` or `phase_name` row to begin with.
--
-- Resetting PhaseId to 0 (no phase) puts the spawns back on the default phase instead of
-- deleting them.

UPDATE `creature` SET `PhaseId` = 0
WHERE `PhaseId` IN (1,403,8186,9007,9009,9014,9015,9016,9022,20322,20415,20434,40445,49405,54958,66565);

UPDATE `gameobject` SET `PhaseId` = 0 WHERE `PhaseId` IN (1,7);