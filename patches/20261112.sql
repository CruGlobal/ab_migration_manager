# ****************************************************************
# 20261112.sql
#
# This patch creates the default plugin links to the AB UI Plugins
# ****************************************************************

# Default AB UI Plugin Entry
# ------------------------------------------------------------

LOCK TABLES `SITE_PLUGIN` WRITE;
/*!40000 ALTER TABLE `SITE_PLUGIN` DISABLE KEYS */;

INSERT INTO `SITE_PLUGIN` (`uuid`, `created_at`, `updated_at`, `properties`, `translations`, `url`, `enabled`, `icon`, `version`)
VALUES
	('ca7e6f86-eff8-4527-9438-5f44ced73a82','2026-05-20 10:32:53','2026-05-20 10:32:53',NULL,X'5B7B226C616E67756167655F636F6465223A22656E222C224E616D65223A2244656661756C7420576562222C224465736372697074696F6E223A2242756E646C656420706C6174666F726D20696E636C75646564207669657720706C7567696E73227D5D','http://web:80/assets/ab_plugins/ab_plugin_default_web/manifest.json',NULL,'fa-puzzle-piece','0.0.0');

/*!40000 ALTER TABLE `SITE_PLUGIN` ENABLE KEYS */;
UNLOCK TABLES;


# Default AB UI Plugin Links
# ------------------------------------------------------------

LOCK TABLES `SITE_PLUGIN_LINK` WRITE;
/*!40000 ALTER TABLE `SITE_PLUGIN_LINK` DISABLE KEYS */;

INSERT INTO `SITE_PLUGIN_LINK` (`uuid`, `created_at`, `updated_at`, `properties`, `platform`, `type`, `url`, `plugin`)
VALUES
	('4ae06966-8640-4f4e-81b5-9508a213ad3c','2026-05-20 10:32:53','2026-05-20 10:32:53',NULL,'web','view','/assets/ab_plugins/ab_plugin_default_web/dist/ABDefaultWeb_web.mjs?v=1779273173001','ca7e6f86-eff8-4527-9438-5f44ced73a82'),
	('d7374fe2-2084-444b-901a-b172d783bf69','2026-05-20 10:32:53','2026-05-20 10:32:53',NULL,'web','properties','/assets/ab_plugins/ab_plugin_default_web/dist/ABDefaultWeb_properties.mjs?v=1779273173000','ca7e6f86-eff8-4527-9438-5f44ced73a82');

/*!40000 ALTER TABLE `SITE_PLUGIN_LINK` ENABLE KEYS */;
UNLOCK TABLES;

