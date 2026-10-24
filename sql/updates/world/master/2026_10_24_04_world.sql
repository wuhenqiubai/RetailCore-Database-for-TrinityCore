-- Quest 59766 "A Good Axe" (Shadowlands, Detrithos) could never be completed.
--
-- The live objective list (client QuestObjective.db2 / wowhead quest=59766) is:
--   398170 - type 0 (MONSTER), object 174912 "[DNT] Bugfix Creature" x5
--   399087 - type 1 (ITEM),    object 999998 "TEMP" x1
--
-- 174912 is a Blizzard-side helper creature that has no spawn anywhere in the
-- world; the five `Mawsworn Armaments` chests (gameobject 352985) are supposed to
-- hand out one kill credit each, which is what makes "check all 5 armaments"
-- work on retail.  Neither this core nor the DB carried that credit: the chest
-- template has an empty `AIName`, and `smart_scripts` has no row for it, so
-- 174912 kill credits are never granted and 398170 stays at 0/5 forever.
--
-- Give the chest a SmartAI that credits 174912 to the player who opens it.
-- Objective 399087 already works: `gameobject_loot_template` 352985 drops item
-- 999998 with QuestRequired = 1, so the item lands in the inventory of a player
-- that has the quest.  `GO_ACTIVATED` is only entered the first time a chest is
-- opened, so each armament grants exactly one credit.

UPDATE `gameobject_template` SET `AIName` = 'SmartGameObjectAI' WHERE `entry` = 352985;

DELETE FROM `smart_scripts` WHERE `entryorguid` = 352985 AND `source_type` = 1;

INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `action_param_string`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `comment`) VALUES
(352985, 1, 0, 0, '', 70, 0, 100, 0, 2, 0, 0, 0, 0, '', 33, 174912, 0, 0, 0, 0, 0, 0, '', 7, 0, 0, 0, 0, 'Mawsworn Armaments - On Loot State Activated - Give kill credit 174912 ([DNT] Bugfix Creature)');
