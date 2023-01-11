# ************************************************************
# 00000000.sql
# 
# Initial patch file, that makes sure our SITE_CONFIG table is
# available.
# ************************************************************


CREATE TABLE IF NOT EXISTS `SITE_CONFIG` (
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` text DEFAULT NULL,
  UNIQUE KEY `key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `SITE_CONFIG` WRITE;
/*!40000 ALTER TABLE `SITE_CONFIG` DISABLE KEYS */;

INSERT INTO `SITE_CONFIG` (`key`, `value`)
VALUES
   ("migration-last-patch", "00000000.sql");

/*!40000 ALTER TABLE `SITE_CONFIG` ENABLE KEYS */;
UNLOCK TABLES;