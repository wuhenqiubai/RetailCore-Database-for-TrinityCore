-- Gilneas Reclamation phasing fix (10.2.7).
--
-- The "Gilneas Recl." phases were only registered in `phase_area` for AreaId 4706
-- (Ruins of Gilneas). The content itself is spawned in AreaId 4714 (Gilneas) and 4755
-- (Gilneas City) on map 0 - 406 of the affected creature spawns carry zoneId 4714/4755.
--
-- PhasingHandler::OnAreaChange only walks AreaTable.ParentAreaID upwards, so a phase registered
-- for the sibling area 4706 is never granted to a player standing in 4714. Every creature using
-- one of these phases is therefore invisible and Gilneas looks empty.
--
-- 4755 inherits from 4714 through ParentAreaID, so registering the phases on 4714 covers the
-- city as well. The 4706 rows are left untouched.

DELETE FROM `phase_area` WHERE `AreaId` = 4714 AND `PhaseId` IN (40396,40657,40658,40659,40660,40661,40662,40663,40664,40665,40666,40667,40668,40669,40670,40671,40672,40673,40674);

INSERT INTO `phase_area` (`AreaId`, `PhaseId`, `Comment`) VALUES
(4714, 40396, 'Gilneas After Recl.'),
(4714, 40657, 'Gilneas Recl. Crusade Members in Aderic''s Repose.'),
(4714, 40658, 'Gilneas Recl.  Greymane and Friends at Gilneas Harbor'),
(4714, 40659, 'Gilneas Recl. Consecrator Hennas in Aderics Repose.'),
(4714, 40660, 'Gilneas Recl. Genn in Aderics Repose2'),
(4714, 40661, 'Gilneas Recl. Lilian and Tess#1'),
(4714, 40662, 'Gilneas Recl. Tess#2'),
(4714, 40663, 'Gilneas Recl. Gate of Gilneas'),
(4714, 40664, 'Gilneas Recl. Genn Tess Lilian in Gilneas City chapel courtyard'),
(4714, 40665, 'Quest - Righteous Fire, Righteous Fury'),
(4714, 40666, 'Quest - Righteous Fire, Righteous Fury MONSTER'),
(4714, 40667, 'Gilneas Recl. Genn Tess Lilian in Gilneas City chapel courtyard after Scarlet Battle'),
(4714, 40668, 'Gilneas Recl. Scarlet Battle'),
(4714, 40669, 'Gilneas Genn in Gilneas before visiting Liams Grave'),
(4714, 40670, 'Gilneas Genn visiting Liams Grave'),
(4714, 40671, 'Gilneas Recl. Lilian and Calia in Pyrewood Village'),
(4714, 40672, 'Gilneas Recl. Tess, Lilian and Calia in Pyrewood Village'),
(4714, 40673, 'Gilneas Recl. Tess, Lilian and Calia in Pyrewood Village BOAT'),
(4714, 40674, 'NewBeginning:  Merithra at the Ancient Bough in the Ohnahran Plains');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 26 AND `SourceEntry` = 4714 AND `SourceGroup` IN (40396,40657,40658,40659,40660,40661,40662,40663,40664,40665,40666,40667,40668,40669,40670,40671,40672,40673,40674);

INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
('26',40396,4714,0,0,47,0,78188,66,0,'',0,0,0,'','Allow Phase 14027 if Quest 59774 IS complete/rewarded'),
('26',40657,4714,0,0,47,0,78177,66,0,'',1,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded'),
('26',40658,4714,0,0,47,0,78181,66,0,'',1,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded'),
('26',40659,4714,0,0,47,0,78181,66,0,'',1,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded'),
('26',40660,4714,0,0,47,0,78181,66,0,'',0,0,0,'','Allow Phase 14027 if Quest 59774 IS complete/rewarded'),
('26',40660,4714,0,0,47,0,78182,66,0,'',1,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded'),
('26',40661,4714,0,0,47,0,78182,66,0,'',0,0,0,'','Allow Phase 14027 if Quest 59774 IS complete/rewarded'),
('26',40661,4714,0,0,47,0,78185,66,0,'',1,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded'),
('26',40662,4714,0,0,47,0,78185,66,0,'',0,0,0,'','Allow Phase 14027 if Quest 59774 IS complete/rewarded'),
('26',40662,4714,0,0,47,0,78186,66,0,'',1,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded'),
('26',40663,4714,0,0,47,0,78185,66,0,'',1,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded'),
('26',40664,4714,0,0,47,0,78186,66,0,'',0,0,0,'','Allow Phase 14027 if Quest 59774 IS complete/rewarded'),
('26',40664,4714,0,0,47,0,78188,66,0,'',1,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded'),
('26',40665,4714,0,0,47,0,78188,8,0,'',0,0,0,'','Quest - Righteous Fire, Righteous Fury'),
('26',40666,4714,0,0,47,0,78188,2,0,'',0,0,0,'','Quest - Righteous Fire, Righteous Fury MONSTER'),
('26',40667,4714,0,0,47,0,78188,66,0,'',0,0,0,'','Allow Phase 14027 if Quest 59774 IS complete/rewarded'),
('26',40667,4714,0,0,47,0,999999,66,0,'',1,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded'),
('26',40668,4714,0,0,47,0,78180,66,0,'',0,0,0,'','Allow Phase 14027 if Quest 59774 IS complete/rewarded'),
('26',40668,4714,0,0,47,0,78188,66,0,'',1,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded'),
('26',40669,4714,0,0,47,0,78188,66,0,'',0,0,0,'','Allow Phase 14027 if Quest 59774 IS complete/rewarded'),
('26',40669,4714,0,0,47,0,78189,66,0,'',1,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded'),
('26',40670,4714,0,0,47,0,78189,66,0,'',0,0,0,'','Allow Phase 14027 if Quest 59774 IS complete/rewarded'),
('26',40670,4714,0,0,47,0,999999,66,0,'',1,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded'),
('26',40671,4714,0,0,47,0,78178,66,0,'',1,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded'),
('26',40671,4714,0,0,47,0,78597,66,0,'',0,0,0,'','Allow Phase 14027 if Quest 59774 IS complete/rewarded'),
('26',40672,4714,0,0,47,0,78178,8,0,'',0,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded'),
('26',40673,4714,0,0,47,0,78178,2,0,'',0,0,0,'','Gilneas Recl. Tess, Lilian and Calia in Pyrewood Village BOAT '),
('26',40674,4714,0,0,47,0,77780,66,0,'',0,0,0,'','Allow Phase 14027 if Quest 59774 IS complete/rewarded'),
('26',40674,4714,0,0,47,0,999999,66,0,'',1,0,0,'','Allow Phase 14027 if Quest 59774 IS NOT complete/rewarded');
