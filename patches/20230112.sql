# ************************************************************
# 20230112.sql
# 
# This patch adds support for caching failed process_manager.trigger requests.
# ************************************************************


#
# 1) Add unique instanceKey column to SITE_PROCESS_INSTANCE
#
ALTER TABLE `SITE_PROCESS_INSTANCE` ADD COLUMN IF NOT EXISTS `instanceKey` varchar(255) DEFAULT NULL;
ALTER TABLE `SITE_PROCESS_INSTANCE` DROP CONSTRAINT IF EXISTS `SITE_PROCESS_INSTANCE_instanceKey`;
ALTER TABLE `SITE_PROCESS_INSTANCE` ADD CONSTRAINT `SITE_PROCESS_INSTANCE_instanceKey` UNIQUE (`instanceKey`);

#
# 2) Create Pending Trigger Table
#
CREATE TABLE IF NOT EXISTS `SITE_PENDING_TRIGGER` (
  `uuid` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `properties` text DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data`)),
  `user` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`user`)),
  PRIMARY KEY (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

#
# 3) Add site definitions for system objects.
#
LOCK TABLES `appbuilder_definition` WRITE;
/*!40000 ALTER TABLE `appbuilder_definition` DISABLE KEYS */;

-- New definitions
INSERT IGNORE INTO `appbuilder_definition` (`id`, `name`, `type`, `json`, `createdAt`, `updatedAt`) 
VALUES
  ('791ab8d5-c4eb-45f1-95b1-f9e05d563c77', 'SITE_PENDING_TRIGGER', 'object', '{\"id\":\"791ab8d5-c4eb-45f1-95b1-f9e05d563c77\",\"type\":\"object\",\"name\":\"SITE_PENDING_TRIGGER\",\"labelFormat\":\"\",\"labelSettings\":{\"isNoLabelDisplay\":0},\"isImported\":0,\"isExternal\":0,\"tableName\":\"SITE_PENDING_TRIGGER\",\"primaryColumnName\":\"uuid\",\"transColumnName\":\"\",\"urlPath\":\"\",\"objectWorkspace\":{\"sortFields\":[],\"filterConditions\":{},\"frozenColumnID\":\"\",\"hiddenFields\":[]},\"isSystemObject\":1,\"translations\":[{\"language_code\":\"en\",\"label\":\"SITE_PENDING_TRIGGER\"}],\"fieldIDs\":[\"a427d4b2-b87a-4f0c-9bd9-12a6a084cac2\",\"7a340aff-fe27-4608-8ada-9c7013933ffe\",\"94497482-d3c6-429d-aa2e-b7c82592ddd3\"],\"importedFieldIDs\":[],\"indexIDs\":[],\"createdInAppID\":\"227bcbb3-437f-4bb5-a5a1-ec3198696206\",\"objectWorkspaceViews\":{\"currentViewID\":\"fcc983c0-58f8-4c9f-8063-b37405e031ae\",\"list\":[{\"id\":\"fcc983c0-58f8-4c9f-8063-b37405e031ae\",\"translations\":[{\"language_code\":\"en\",\"label\":\"grid\"}],\"isDefaultView\":true,\"name\":\"Default Grid\",\"sortFields\":[],\"filterConditions\":{},\"frozenColumnID\":\"\",\"type\":\"grid\"}]}}', '2022-12-02 08:44:18', '2022-12-13 08:44:14'),
  ('7a340aff-fe27-4608-8ada-9c7013933ffe', 'SITE_PENDING_TRIGGER->data', 'field', '{\"id\":\"7a340aff-fe27-4608-8ada-9c7013933ffe\",\"type\":\"field\",\"key\":\"json\",\"icon\":\"font\",\"isImported\":0,\"columnName\":\"data\",\"settings\":{\"showIcon\":1,\"required\":0,\"unique\":0,\"validationRules\":\"[]\",\"width\":100},\"translations\":[{\"language_code\":\"en\",\"label\":\"data\"}]}', '2022-12-02 08:44:58', '2022-12-02 08:44:58'),
  ('94497482-d3c6-429d-aa2e-b7c82592ddd3', 'SITE_PENDING_TRIGGER->user', 'field', '{\"id\":\"94497482-d3c6-429d-aa2e-b7c82592ddd3\",\"type\":\"field\",\"key\":\"json\",\"icon\":\"font\",\"isImported\":0,\"columnName\":\"user\",\"settings\":{\"showIcon\":1,\"required\":0,\"unique\":0,\"validationRules\":\"[]\",\"width\":100},\"translations\":[{\"language_code\":\"en\",\"label\":\"user\"}]}', '2022-12-13 08:44:14', '2022-12-13 08:44:14'),
  ('a427d4b2-b87a-4f0c-9bd9-12a6a084cac2', 'SITE_PENDING_TRIGGER->key', 'field', '{\"id\":\"a427d4b2-b87a-4f0c-9bd9-12a6a084cac2\",\"type\":\"field\",\"key\":\"string\",\"icon\":\"font\",\"isImported\":0,\"columnName\":\"key\",\"settings\":{\"showIcon\":1,\"required\":0,\"unique\":0,\"validationRules\":\"[]\",\"default\":\"\",\"supportMultilingual\":0,\"width\":100},\"translations\":[{\"language_code\":\"en\",\"label\":\"key\"}]}', '2022-12-02 08:44:50', '2022-12-02 08:44:50'),
  ('fcfbf1ec-294c-43bd-a6c4-044dbe704052', 'ProcessInstance->instanceKey', 'field', '{\"id\":\"fcfbf1ec-294c-43bd-a6c4-044dbe704052\",\"type\":\"field\",\"key\":\"string\",\"icon\":\"font\",\"isImported\":0,\"columnName\":\"instanceKey\",\"settings\":{\"showIcon\":1,\"required\":1,\"unique\":0,\"validationRules\":\"[]\",\"default\":\"\",\"supportMultilingual\":0,\"width\":150},\"translations\":[{\"language_code\":\"en\",\"label\":\"instanceKey\"}]}', '2022-12-02 08:42:37', '2022-12-02 08:42:37');

-- Add new fieldID to exisiting definition
UPDATE `appbuilder_definition` 
SET `json` = JSON_SET(`json`, '$.fieldIDs', JSON_ARRAY("d5afbc83-17dd-4b38-bded-1bf3f4594135","ffdc5c1f-8451-4ed8-b22b-048309d65d44","60065bf3-70b0-4c05-88a6-b9c06277aa29","b957a75d-65aa-427c-a813-63211658649a","147ab095-d8f3-4622-8415-755893d57f40","5b956ab7-5e7b-4471-a377-48e0ec193b05","5c699b8a-3e52-4a95-af17-00a91774d571","b4aead9c-9e97-45bf-a652-f7e979a8f235","fcfbf1ec-294c-43bd-a6c4-044dbe704052"))
WHERE `id` = '2ba85be0-78db-4eda-ba43-c2c4e3831849';

/*!40000 ALTER TABLE `appbuilder_definition` ENABLE KEYS */;
UNLOCK TABLES;
