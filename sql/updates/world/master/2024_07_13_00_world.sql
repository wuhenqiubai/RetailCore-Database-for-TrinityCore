-- Evoker Pyre (357211) was linked to spell 23512 through SPELL_LINK_HIT.
-- 23512 is a self centered TARGET_UNIT_SRC_AREA_ENEMY damage spell (20 yd radius, 597 base damage),
-- and Spell::DoTriggersOnSpellHit() makes the *hit unit* the caster of a linked spell, so every
-- Pyre hit made the victim blow up everything hostile around itself - including the evoker that
-- cast Pyre. Pyre damage is handled by spell_evo_pyre (393568 -> 357212) instead.
-- 375087 (Dragonrage) and 381525 (Fire Breath damage) carried the same bogus link; Fire Breath
-- damage is handled by spell_evo_fire_breath (357208 -> 357209).
DELETE FROM `spell_linked_spell` WHERE `spell_effect` = 23512 AND `type` = 1 AND `spell_trigger` IN (357211, 375087, 381525);
