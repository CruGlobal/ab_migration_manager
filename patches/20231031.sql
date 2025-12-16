# ************************************************************
# 20231031.sql
#
# This patch adds KEY and SECRET tables
# ************************************************************


# Dump of table SITE_KEY
# ------------------------------------------------------------
-- FIX: Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails
-- when the table already exists
-- DROP TABLE IF EXISTS `SITE_KEY`;

CREATE TABLE IF NOT EXISTS `SITE_KEY` (
  `uuid` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `properties` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `Key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `DefinitionID` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`uuid`),
  UNIQUE KEY `SITE_KEY_Key` (`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;



# Dump of table AB_JOINMN_KEY_ROLE_Roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `AB_JOINMN_KEY_ROLE_roles`;

CREATE TABLE `AB_JOINMN_KEY_ROLE_roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `Key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ROLE` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Key_Roles` (`Key`),
  KEY `Role_Key134` (`ROLE`),
  CONSTRAINT `Key_Roles` FOREIGN KEY (`Key`) REFERENCES `SITE_KEY` (`uuid`) ON DELETE SET NULL,
  CONSTRAINT `Role_Key134` FOREIGN KEY (`ROLE`) REFERENCES `SITE_ROLE` (`uuid`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;



# Dump of table SITE_SECRET
# ------------------------------------------------------------

DROP TABLE IF EXISTS `SITE_SECRET`;

CREATE TABLE `SITE_SECRET` (
  `uuid` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `properties` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `Name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Secret` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `DefinitionID` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;


#
# 1) Add the KEY object and fields
# 2) Add the SECRET object and fields
# 3) Add a connect field between ROLE and KEY tables
#

LOCK TABLES `appbuilder_definition` WRITE;

INSERT INTO `appbuilder_definition` (`id`, `name`, `type`, `json`, `createdAt`, `updatedAt`)
VALUES
	('d734fe8c-b615-446c-8a5f-793ddece19f9','KEY','object','{\"id\":\"d734fe8c-b615-446c-8a5f-793ddece19f9\",\"type\":\"object\",\"name\":\"KEY\",\"labelFormat\":\"{b86eb947-06f2-47e4-b79a-9aaf896a0b69}\",\"isImported\":0,\"isExternal\":0,\"tableName\":\"SITE_KEY\",\"primaryColumnName\":\"uuid\",\"transColumnName\":\"\",\"urlPath\":\"\",\"objectWorkspace\":{\"sortFields\":[],\"filterConditions\":{},\"frozenColumnID\":\"\",\"hiddenFields\":[]},\"isSystemObject\":\"true\",\"translations\":[{\"language_code\":\"en\",\"label\":\"Key\"}],\"fieldIDs\":[\"b86eb947-06f2-47e4-b79a-9aaf896a0b69\",\"8ed87a85-14c0-4420-8c64-999a43d456c9\",\"8aaf7041-e401-443d-abf7-5d698171400a\"],\"importedFieldIDs\":[],\"indexIDs\":[],\"objectWorkspaceViews\":{\"currentViewID\":\"5def4544-1cc7-43e3-adab-48ae5de63eb3\",\"list\":[{\"id\":\"5def4544-1cc7-43e3-adab-48ae5de63eb3\",\"translations\":[{\"language_code\":\"en\",\"label\":\"grid\"}],\"isDefaultView\":true,\"name\":\"Default Grid\",\"sortFields\":[],\"filterConditions\":{},\"frozenColumnID\":\"\",\"hiddenFields\":[],\"type\":\"grid\"}]}}','2023-10-16 10:27:24','2023-10-16 10:27:24'),
	('8ed87a85-14c0-4420-8c64-999a43d456c9','KEY->DefinitionID','field','{\"id\":\"8ed87a85-14c0-4420-8c64-999a43d456c9\",\"type\":\"field\",\"key\":\"string\",\"icon\":\"font\",\"isImported\":0,\"columnName\":\"DefinitionID\",\"settings\":{\"showIcon\":1,\"required\":1,\"unique\":0,\"validationRules\":\"[]\",\"default\":\"\",\"supportMultilingual\":0,\"width\":160},\"translations\":[{\"language_code\":\"en\",\"label\":\"DefinitionID\"}]}','2023-10-16 10:27:24','2023-10-16 10:27:24'),
	('b86eb947-06f2-47e4-b79a-9aaf896a0b69','KEY->Key','field','{\"id\":\"b86eb947-06f2-47e4-b79a-9aaf896a0b69\",\"type\":\"field\",\"key\":\"string\",\"icon\":\"font\",\"isImported\":0,\"columnName\":\"Key\",\"settings\":{\"showIcon\":1,\"required\":1,\"unique\":0,\"validationRules\":\"[]\",\"default\":\"\",\"supportMultilingual\":0,\"width\":100},\"translations\":[{\"language_code\":\"en\",\"label\":\"Key\"}]}','2023-10-16 10:27:24','2023-10-16 10:27:24'),
	('8aaf7041-e401-443d-abf7-5d698171400a','KEY->Roles','field','{\"id\":\"8aaf7041-e401-443d-abf7-5d698171400a\",\"key\":\"connectObject\",\"label\":\"Roles\",\"columnName\":\"roles\",\"settings\":{\"linkObject\":\"c33692f3-26b7-4af3-a02e-139fb519296d\",\"linkType\":\"many\",\"linkViaType\":\"many\",\"linkColumn\":\"8ff70bee-6cb6-11ee-b40b-02420a00010d\",\"isSource\":1,\"showIcon\":1,\"required\":0,\"width\":0,\"unique\":0,\"isCustomFK\":0,\"indexField\":\"\",\"indexField2\":\"\"},\"translations\":[{\"language_code\":\"en\",\"label\":\"Roles\"}]}','2023-10-16 10:27:24','2023-10-16 10:27:24'),
	('8ff70bee-6cb6-11ee-b40b-02420a00010d','ROLE->Keys','field','{\"id\":\"8ff70bee-6cb6-11ee-b40b-02420a00010d\",\"key\":\"connectObject\",\"columnName\":\"keys\",\"settings\":{\"linkObject\":\"d734fe8c-b615-446c-8a5f-793ddece19f9\",\"linkType\":\"many\",\"linkViaType\":\"many\",\"linkColumn\":\"8aaf7041-e401-443d-abf7-5d698171400a\",\"isSource\":0,\"showIcon\":1,\"required\":0,\"width\":0,\"unique\":0,\"isCustomFK\":0,\"indexField\":\"\",\"indexField2\":\"\"},\"translations\":[{\"language_code\":\"en\",\"label\":\"Keys\"}]}','2023-10-16 10:27:24','2023-10-16 10:27:24'),
	('db5b3b26-5300-4c92-bc73-8ce4f4696992','SECRET','object','{\"id\":\"db5b3b26-5300-4c92-bc73-8ce4f4696992\",\"type\":\"object\",\"name\":\"SECRET\",\"isImported\":\"0\",\"isExternal\":\"0\",\"tableName\":\"SITE_SECRET\",\"primaryColumnName\":\"uuid\",\"transColumnName\":\"\",\"urlPath\":\"\",\"objectWorkspace\":{\"sortFields\":[],\"filterConditions\":{},\"frozenColumnID\":\"\",\"hiddenFields\":[]},\"isSystemObject\":\"true\",\"translations\":[{\"language_code\":\"en\",\"label\":\"Secret\"}],\"fieldIDs\":[\"ac64f465-8fdd-4d0f-8752-1e23f55aea4e\",\"7d4b2c26-a53e-44a7-922e-93ba24f30c5f\",\"f9e694aa-bba1-466a-b2c3-440985cb0c7e\"],\"objectWorkspaceViews\":{\"currentViewID\":\"5def4544-1cc7-43e3-adab-48ae5de63eb3\",\"list\":[{\"id\":\"5def4544-1cc7-43e3-adab-48ae5de63eb3\",\"translations\":[{\"language_code\":\"en\",\"label\":\"grid\"}],\"isDefaultView\":true,\"name\":\"Default Grid\",\"sortFields\":[],\"filterConditions\":{},\"frozenColumnID\":\"\",\"hiddenFields\":[],\"type\":\"grid\"}]}}','2023-10-16 10:27:24','2023-10-16 10:27:24'),
	('7d4b2c26-a53e-44a7-922e-93ba24f30c5f','SECRET->Secret','field','{\"id\":\"7d4b2c26-a53e-44a7-922e-93ba24f30c5f\",\"type\":\"field\",\"key\":\"LongText\",\"icon\":\"align-right\",\"isImported\":0,\"columnName\":\"Secret\",\"settings\":{\"showIcon\":1,\"required\":1,\"unique\":0,\"validationRules\":\"[]\",\"default\":\"\",\"supportMultilingual\":0,\"width\":100},\"translations\":[{\"language_code\":\"en\",\"label\":\"Secret\"}]}','2023-10-16 10:27:24','2023-10-16 10:27:24'),
	('ac64f465-8fdd-4d0f-8752-1e23f55aea4e','SECRET->Name','field','{\"id\":\"ac64f465-8fdd-4d0f-8752-1e23f55aea4e\",\"type\":\"field\",\"key\":\"string\",\"icon\":\"font\",\"isImported\":0,\"columnName\":\"Name\",\"settings\":{\"showIcon\":1,\"required\":1,\"unique\":0,\"validationRules\":\"[]\",\"default\":\"\",\"supportMultilingual\":0,\"width\":100},\"translations\":[{\"language_code\":\"en\",\"label\":\"Name\"}]}','2023-10-16 10:27:24','2023-10-16 10:27:24'),
	('f9e694aa-bba1-466a-b2c3-440985cb0c7e','SECRET->DefinitionID','field','{\"id\":\"f9e694aa-bba1-466a-b2c3-440985cb0c7e\",\"type\":\"field\",\"key\":\"string\",\"icon\":\"font\",\"isImported\":0,\"columnName\":\"DefinitionID\",\"settings\":{\"showIcon\":1,\"required\":1,\"unique\":0,\"validationRules\":\"[]\",\"default\":\"\",\"supportMultilingual\":0,\"width\":160},\"translations\":[{\"language_code\":\"en\",\"label\":\"DefinitionID\"}]}','2023-10-16 10:27:24','2023-10-16 10:27:24'),
	('c33692f3-26b7-4af3-a02e-139fb519296d','ROLE','object','{\"id\":\"c33692f3-26b7-4af3-a02e-139fb519296d\",\"type\":\"object\",\"name\":\"ROLE\",\"labelFormat\":\"\",\"isImported\":\"0\",\"isExternal\":\"0\",\"tableName\":\"SITE_ROLE\",\"primaryColumnName\":\"uuid\",\"transColumnName\":\"\",\"urlPath\":\"\",\"objectWorkspace\":{\"frozenColumnID\":\"\",\"filterConditions\":{\"glue\":\"and\"},\"sortFields\":[],\"hiddenFields\":[]},\"isSystemObject\":\"true\",\"translations\":[{\"language_code\":\"en\",\"label\":\"Role\"}],\"fieldIDs\":[\"f1fccbbf-f226-4e9e-aa6a-119f8cc309b6\",\"4585d5cb-0eea-461d-a326-61187c88520f\",\"e4c760e1-ff9c-40dc-80d5-b1f76d59e140\",\"9d6d77be-eef9-46c5-b7f2-df44d44d9e61\",\"07e6a725-aba0-42e6-9b38-984fef7e8274\",\"9d1b0ee4-6807-4938-9df7-b551dcea7eaa\",\"8ff70bee-6cb6-11ee-b40b-02420a00010d\"],\"objectWorkspaceViews\":{\"currentViewID\":\"bee1cedc-f5f8-41d8-8558-a0465824d5b2\",\"list\":[{\"id\":\"bee1cedc-f5f8-41d8-8558-a0465824d5b2\",\"translations\":[{\"language_code\":\"en\",\"label\":\"grid\"}],\"isDefaultView\":\"true\",\"name\":\"Default Grid\",\"filterConditions\":{\"glue\":\"and\"},\"frozenColumnID\":\"\",\"type\":\"grid\"}]}}',NULL,'2022-04-07 03:08:47')
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    type = VALUES(type),
    json = VALUES(json),
    createdAt = VALUES(createdAt),
    updatedAt = VALUES(updatedAt);

UNLOCK TABLES;
