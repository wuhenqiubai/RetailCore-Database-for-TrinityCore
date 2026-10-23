-- Register the spawn phases that no area ever received.
--
-- ObjectMgr::LoadAreaPhases() builds _phaseInfoByArea from `phase_area` only, and
-- PhasingHandler::OnAreaChange() walks AreaTable.ParentAreaID upwards. A phase that
-- is not listed in `phase_area` for the spawn's area (or one of its parents) is never
-- added to the player's PhaseShift, so every creature/gameobject using it is invisible
-- unless the player has GM mode on (PhasingHandler::SetAlwaysVisible).
--
-- An audit of both Gilneas maps found two such gaps. All phase ids below exist in the
-- client Phase.db2 store, so they are valid phases that simply were never registered.

-- ---------------------------------------------------------------------------
-- 1) Ruins of Gilneas (map 0, AreaId 4706 and its sub-areas)
--    Phase 274 "Gilneas Act I" carries the whole Gilneas Reclamation content:
--    311 creature spawns (Forsaken Vanguard, Worgen Rebel, Deathstalker Commander
--    Belmont, ...) in areas 4706/5434/5440/5441/5443/5444 and 19 gameobject spawns
--    in areas 5434/5440. Sub-areas inherit the phase from their parent, so a single
--    row on 4706 is enough.
-- ---------------------------------------------------------------------------
DELETE FROM `phase_area` WHERE `AreaId` = 4706 AND `PhaseId` = 274;
INSERT INTO `phase_area` (`AreaId`, `PhaseId`, `Comment`) VALUES
(4706, 274, 'Ruins of Gilneas - Gilneas Act I (Reclamation spawns)');

-- ---------------------------------------------------------------------------
-- 2) Gilneas (map 654, AreaId 4714 and its sub-areas)
--    The Cataclysm-era worgen starting zone keeps its herbs, quest objects and
--    furniture in low "act" phases that were never registered either: 172, 182,
--    183, 184, 186, 187 and 188. That hides ~150 gameobjects, e.g. the 44 Moonleaf
--    and 31 Old Journal Page in The Blackwald (4730) / Stormglen Village (4731).
--    No creature on map 654 uses these phases, so nothing overlaps.
-- ---------------------------------------------------------------------------
DELETE FROM `phase_area` WHERE `AreaId` = 4714 AND `PhaseId` IN (172,182,183,184,186,187,188);
INSERT INTO `phase_area` (`AreaId`, `PhaseId`, `Comment`) VALUES
(4714, 172, 'Gilneas - worgen intro props'),
(4714, 182, 'Gilneas - worgen intro props'),
(4714, 183, 'Gilneas - worgen intro props'),
(4714, 184, 'Gilneas - worgen intro props'),
(4714, 186, 'Gilneas - worgen intro props (herbs, quest objects)'),
(4714, 187, 'Gilneas - worgen intro props'),
(4714, 188, 'Gilneas - worgen intro props (Disturbed Soil, Aderic''s Tomb)');

-- ---------------------------------------------------------------------------
-- 3) Teleport shortcuts into the populated map 654 version of Gilneas.
--    The character lives on map 0, where Gilneas only exists as "Ruins of Gilneas"
--    (4706, the Reclamation). The Cataclysm worgen zone (4714) with Stormglen
--    Village, The Blackwald, Keel Harbor and Duskhaven is a separate map (654) and
--    is fully populated. These let you inspect it without a GM teleport.
-- ---------------------------------------------------------------------------
DELETE FROM `game_tele` WHERE `id` IN (4100,4101,4102,4103,4104);
INSERT INTO `game_tele` (`id`, `position_x`, `position_y`, `position_z`, `orientation`, `map`, `name`) VALUES
(4100, -2456.30, 1550.22,  18.7750, 2.02458, 654, 'Gilneas2Stormglen'),
(4101, -2363.03, 1522.52,   4.7765, 0.00000, 654, 'Gilneas2Blackwald'),
(4102, -1322.30, 2120.34,   5.7143, 3.15905, 654, 'Gilneas2KeelHarbor'),
(4103, -1944.75, 2243.60,  35.8683, 0.00000, 654, 'Gilneas2Duskhaven'),
(4104, -1768.08, 1449.61,  20.2549, 1.86038, 654, 'Gilneas2City');
