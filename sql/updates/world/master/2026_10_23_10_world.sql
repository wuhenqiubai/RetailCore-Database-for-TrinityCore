-- Remove phase_area rows for areas that do not exist in AreaTable.
--
-- AreaId 895 and 1502 are absent from the client AreaTable (8824 rows in
-- AreaTable.db2), so ObjectMgr::LoadAreaPhases drops these two rows at startup
-- with "Area {} defined in phase_area does not exist, skipped.". No creature or
-- gameobject spawn references phase 19831 or 20389, so nothing is lost.

DELETE FROM `phase_area` WHERE `AreaId` IN (895,1502);
