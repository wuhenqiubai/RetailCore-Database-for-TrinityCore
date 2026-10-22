-- Evoker: Eternity Surge (359073) was never scripted, so the empowered channel
-- completed without ever casting its damage spell (359077) - nothing happened.
DELETE FROM `spell_script_names` WHERE `ScriptName` IN ('spell_evo_eternity_surge', 'spell_evo_eternity_surge_damage');
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(359073, 'spell_evo_eternity_surge'),
(359077, 'spell_evo_eternity_surge_damage');
