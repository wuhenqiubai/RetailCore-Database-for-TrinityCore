-- Cleanup of malformed locale codes and one stray phase registration.
--
-- 1) `creature_template_locale` contains 1102 rows and `quest_offer_reward_locale` 29 rows
--    whose `locale` column is not a valid locale name (' deD' with a leading space, and
--    'frFr' with the wrong casing). LocaleMgr::GetLocaleByName() returns LOCALE_none for
--    both, so the loader silently skips those rows - they were dead weight.
--
--    Every one of them has a twin row with the correct locale code that already carries the
--    same text, so they are simply dropped instead of being renamed (renaming would collide
--    with the existing primary key (entry/ID, locale)).
--
-- 2) `phase_area` had a single row registered on AreaId 13643. 13643 is "The Great Sea" in
--    the 10.2.7 client AreaTable.db2; the Emerald Dream is 14529 and already carries the very
--    same PhaseId 40152 ("EmerlandDreamAfterNewBeginning"), so the 13643 row only granted the
--    Emerald Dream phase to players standing in the Great Sea.

DELETE FROM `creature_template_locale` WHERE BINARY `locale` = ' deD';
DELETE FROM `quest_offer_reward_locale` WHERE BINARY `locale` = 'frFr';

DELETE FROM `phase_area` WHERE `AreaId` = 13643 AND `PhaseId` = 40152;
