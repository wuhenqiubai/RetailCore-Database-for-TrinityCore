DELIMITER ;;
CREATE PROCEDURE 2024_05_25_08_world_safe_locs_transportspawn() BEGIN
  IF NOT EXISTS (SELECT * FROM `information_schema`.`columns` WHERE `table_schema`=SCHEMA() AND `table_name`='world_safe_locs' AND `column_name`='TransportSpawnId') THEN
    ALTER TABLE `world_safe_locs` ADD `TransportSpawnId` bigint unsigned DEFAULT NULL AFTER `Facing`;
  END IF;
END;;

DELIMITER ;
CALL 2024_05_25_08_world_safe_locs_transportspawn();

DROP PROCEDURE IF EXISTS 2024_05_25_08_world_safe_locs_transportspawn;
