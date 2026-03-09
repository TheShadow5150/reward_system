ALTER TABLE `characters` 
ADD COLUMN `last_daily` INT(11) DEFAULT 0,
ADD COLUMN `daily_streak` INT(11) DEFAULT 0,
ADD COLUMN `invest_amount` INT(11) DEFAULT 0,
ADD COLUMN `invest_remaining` INT(11) DEFAULT 0;