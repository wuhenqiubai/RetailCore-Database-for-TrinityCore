-- Remove dead `phase_area` rows.
--
-- These 27 rows reference 23 PhaseIds that exist neither in the client's Phase.db2 (20349 ids)
-- nor in `hotfixes`.`phase` (2332 ids). ObjectMgr::LoadAreaPhases drops them at startup
-- ("Phase {} defined in `phase_area` does not exist, skipped."), so deleting them only
-- removes startup log noise - no runtime behaviour changes.

DELETE FROM `phase_area` WHERE `PhaseId` IN (9007,9009,9014,9015,9016,9020,9021,9022,9031,9032,9035,9036,9037,19895,20322,20338,20415,20425,20426,20427,20428,20434,21434);
