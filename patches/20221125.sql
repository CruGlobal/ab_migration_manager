# ************************************************************
# 20221125.sql
# 
# This patch introduces our Switcheroo changes.
# ************************************************************


#
# 1) Insert the Switcheroo Role
#

LOCK TABLES `SITE_ROLE` WRITE;
/*!40000 ALTER TABLE `SITE_ROLE` DISABLE KEYS */;

INSERT IGNORE INTO `SITE_ROLE` (`uuid`, `created_at`, `updated_at`, `properties`, `translations`, `Default Role`)
VALUES
  ('320ef94a-73b5-476e-9db4-c08130c64bb8','2022-11-15 05:02:54','2022-11-15 05:02:54',NULL,'[{\"language_code\":\"en\",\"name\":\"Switcheroo\",\"description\":\"Allow the user to impersonate other users.\"}]',0);

/*!40000 ALTER TABLE `SITE_ROLE` ENABLE KEYS */;
UNLOCK TABLES;


#
# 2) Update the SITE_ROWLOG table to include the usernameReal column
#
# NOTE: mariadb supports the ADD COLUMN IF NOT EXISTS,  mysql does not.

ALTER TABLE `SITE_ROWLOG` ADD COLUMN IF NOT EXISTS `usernameReal` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL;