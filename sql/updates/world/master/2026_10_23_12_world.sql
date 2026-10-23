-- Gilneas phasing follow-up (10.2.7): the quest gating that kept the whole zone invisible.
--
-- 1) `phase_area` rows for the Ruins of Gilneas (AreaId 4706) and Gilneas (4714) were gated by
--    CONDITION_SOURCE_TYPE_PHASE rows keyed on the "Gilneas Reclamation" quest chain
--    (78177..78189). That chain is self-referential in the shipped data, so no phase is ever
--    granted to a player:
--      * phase 40658 - which hosts Calia Menethil / Tess Greymane, the NPCs that hand out and
--        complete 78177/78178 - is only enabled once 78181 is rewarded;
--      * phase 40672 - the phase of the 78178 turn-in NPC - is only enabled while 78178 is
--        in progress, i.e. after it has already been obtained from that very NPC.
--    PhasingHandler::OnConditionChange therefore never adds these phases to a normal player's
--    PhaseShift, and since none of the phases is DEFAULT_PHASE (169) nothing in the zone is
--    visible - only `.gm on` shows it, because SetGameMaster() calls SetAlwaysVisible().
--    Dropping the gating makes the Reclamation layer permanently visible.
--
-- 2) Gilneas City on map 654 is phased by the Cataclysm worgen starting experience. Its phases
--    live in the hotfix phase store (hotfixes.phase, Flags = 20) but were never registered in
--    `phase_area` for 4714, so the districts of Gilneas City showed no NPCs at all. The peaceful
--    / quest-stage phases are registered below; the invasion phases (40365 Rampaging Worgen,
--    40375 Bloodfang Lurker, 40379 Bloodfang Stalker, 40381 Frenzied Stalker) are deliberately
--    left out so the city stays explorable instead of being overrun by 326 hostile stalkers.
--
-- 4755 (Gilneas City) and its districts 4756..4762 inherit from 4714 through
-- AreaTable.ParentAreaID, so registering on 4714 covers the city as well.

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 26 AND `SourceEntry` = 4706;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 26 AND `SourceEntry` = 4714 AND `SourceGroup` BETWEEN 40657 AND 40674;

DELETE FROM `phase_area` WHERE `AreaId` = 4714 AND `PhaseId` IN (171,40364,40366,40368,40369,40370,40371,40372,40376,40377,40378,40380);

INSERT INTO `phase_area` (`AreaId`, `PhaseId`, `Comment`) VALUES
(4714, 171, 'Gilneas City - Cathedral Quarter props'),
(4714, 40364, 'Gilneas City - Gilneas City Guard, Prince Liam Greymane'),
(4714, 40366, 'Gilneas City - Captain Broderick'),
(4714, 40368, 'Gilneas City - Tobias Mistmantle, Lord Darius Crowley'),
(4714, 40369, 'Gilneas City - Gilnean Royal Guard, King Genn Greymane, Lord Godfrey'),
(4714, 40370, 'Gilneas City - Josiah Avery'),
(4714, 40371, 'Gilneas City - Gilnean Mastiff, Lorna Crowley'),
(4714, 40372, 'Gilneas City - King Genn Greymane'),
(4714, 40376, 'Gilneas City - survivors and city vendors'),
(4714, 40377, 'Gilneas City - Crowley\'s Horse'),
(4714, 40378, 'Gilneas City - Northgate Rebel'),
(4714, 40380, 'Gilneas City - Northgate Rebel, Lord Darius Crowley');
