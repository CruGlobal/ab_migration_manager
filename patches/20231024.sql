# ************************************************************
# 20231024.sql
# 
# This patch adds the _system_ user in our SITE_USER table.
# _system_ is used for automatically generated CRON tasks and 
# other processes not triggered directly by a USER.
# ************************************************************

INSERT IGNORE INTO `SITE_USER` (`uuid`, `created_at`, `updated_at`, `properties`, `failedLogins`, `lastLogin`, `isActive`, `sendEmailNotifications`, `username`, `password`, `salt`, `email`, `languageCode`)
VALUES
	('c73b3246-e816-4529-915b-377513137923','2023-10-24 08:08:08','2023-10-24 08:08:08',NULL,0,NULL,0,0,'_system_',NULL,NULL,NULL,'en');