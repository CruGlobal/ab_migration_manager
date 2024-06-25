# ************************************************************
# 20240619.sql
#
# This patch creates a process instance definition table
# linked to SITE_PROCESS_INSTANCE
# ************************************************************

#
# 1) Create Process Definition Table
#
CREATE TABLE IF NOT EXISTS `SITE_PROCESS_DEFINITION` (
   `uuid` varchar(255) NOT NULL,
   `created_at` datetime DEFAULT NULL,
   `updated_at` datetime DEFAULT NULL,
   `hash` varchar(255) NOT NULL UNIQUE,
   `definition` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`definition`)),
   PRIMARY KEY (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

#
# 2) Add connection to SITE_PROCESS_INSTANCE
#
ALTER TABLE `SITE_PROCESS_INSTANCE` DROP CONSTRAINT IF EXISTS `definition`;
ALTER TABLE `SITE_PROCESS_INSTANCE` ADD COLUMN IF NOT EXISTS `definition` varchar(255) DEFAULT NULL;
ALTER TABLE `SITE_PROCESS_INSTANCE` ADD CONSTRAINT
   FOREIGN KEY (`definition`) REFERENCES `SITE_PROCESS_DEFINITION` (`uuid`);

#
# 3) Add site definitions for system objects.
#
LOCK TABLES `appbuilder_definition` WRITE;
/*!40000 ALTER TABLE `appbuilder_definition` DISABLE KEYS */;

-- New definitions
INSERT IGNORE INTO `appbuilder_definition` (`id`, `name`, `type`, `json`, `createdAt`, `updatedAt`)
VALUES
   (
      'af91fc75-fb73-4d71-af14-e22832eb5915',
      'SITE_PROCESS_DEFINITION',
      'object',
      '{\"id\":\"af91fc75-fb73-4d71-af14-e22832eb5915\",\"type\":\"object\",\"name\":\"SITE_PROCESS_DEFINITION\",\"labelFormat\":\"\",\"labelSettings\":{\"isNoLabelDisplay\":0},\"isImported\":0,\"isExternal\":0,\"tableName\":\"SITE_PROCESS_DEFINITION\",\"primaryColumnName\":\"uuid\",\"transColumnName\":\"\",\"urlPath\":\"\",\"objectWorkspace\":{\"sortFields\":[],\"filterConditions\":[],\"frozenColumnID\":\"\",\"hiddenFields\":[]},\"isSystemObject\":1,\"translations\":[{\"language_code\":\"en\",\"label\":\"ProcessDefinition\"}],\"fieldIDs\":[\"2fc91889-b0fa-41e9-b945-6d4dfebf278b\",\"b3294ea1-fc6f-41a2-8cb3-9a6cbddd9bcf\",\"302fea23-76b2-495e-acdc-8a1c0c7581a0\"],\"importedFieldIDs\":[],\"indexIDs\":[],\"createdInAppID\":\"227bcbb3-437f-4bb5-a5a1-ec3198696206\"}',
      '2024-06-19 00:00:00',
      '2024-06-19 00:00:00'
   ),
   (
      '2fc91889-b0fa-41e9-b945-6d4dfebf278b',
      'SITE_PROCESS_DEFINITION->definition',
      'field',
      '{\"id\":\"2fc91889-b0fa-41e9-b945-6d4dfebf278b\",\"type\":\"field\",\"key\":\"json\",\"icon\":\"font\",\"isImported\":0,\"columnName\":\"definition\",\"settings\":{\"showIcon\":1,\"required\":0,\"unique\":0,\"validationRules\":\"[]\",\"width\":140},\"translations\":[{\"language_code\":\"en\",\"label\":\"definition\"}]}',
      '2024-06-19 00:00:00',
      '2024-06-19 00:00:00'
   ),
   (
      'b3294ea1-fc6f-41a2-8cb3-9a6cbddd9bcf',
      'SITE_PROCESS_DEFINITION->hash',
      'field',
      '{\"id\":\"b3294ea1-fc6f-41a2-8cb3-9a6cbddd9bcf\",\"type\":\"field\",\"key\":\"string\",\"icon\":\"font\",\"isImported\":0,\"columnName\":\"hash\",\"settings\":{\"showIcon\":1,\"required\":0,\"unique\":0,\"validationRules\":\"[]\",\"default\":\"\",\"supportMultilingual\":0,\"width\":100},\"translations\":[{\"language_code\":\"en\",\"label\":\"hash\"}]}',
      '2024-06-19 00:00:00',
      '2024-06-19 00:00:00'
   ),
   (
      '302fea23-76b2-495e-acdc-8a1c0c7581a0',
      'SITE_PROCESS_DEFINITION->instance',
      'field',
      '{\"id\":\"302fea23-76b2-495e-acdc-8a1c0c7581a0\",\"type\":\"field\",\"key\":\"connectObject\",\"icon\":\"external-link\",\"isImported\":0,\"columnName\":\"instances\",\"settings\":{\"showIcon\":1,\"linkObject\":\"2ba85be0-78db-4eda-ba43-c2c4e3831849\",\"linkType\":\"many\",\"linkViaType\":\"one\",\"isCustomFK\":0,\"indexField\":\"\",\"indexField2\":\"\",\"isSource\":0,\"width\":140,\"required\":0,\"unique\":0,\"linkColumn\":\"150eeffc-8541-4577-bc59-4b10191e47b1\"},\"translations\":[{\"language_code\":\"en\",\"label\":\"instances\"}]}',
      '2024-06-19 00:00:00',
      '2024-06-19 00:00:00'
   ),
   (
      '150eeffc-8541-4577-bc59-4b10191e47b1',
      'SITE_PROCESS_INSTANCE->definition',
      'field',
      '{\"id\":\"150eeffc-8541-4577-bc59-4b10191e47b1\",\"type\":\"field\",\"key\":\"connectObject\",\"icon\":\"external-link\",\"isImported\":0,\"columnName\":\"definition\",\"settings\":{\"showIcon\":1,\"required\":0,\"unique\":0,\"validationRules\":\"[]\",\"linkObject\":\"af91fc75-fb73-4d71-af14-e22832eb5915\",\"linkType\":\"one\",\"linkViaType\":\"many\",\"linkColumn\":\"302fea23-76b2-495e-acdc-8a1c0c7581a0\",\"isSource\":1,\"isCustomFK\":0,\"indexField\":\"\",\"indexField2\":\"\",\"width\":140},\"translations\":[{\"language_code\":\"en\",\"label\":\"definition\"}]}',
      '2024-06-19 00:00:00',
      '2024-06-19 00:00:00'
   );

-- Add new fieldID to exisiting definition
UPDATE `appbuilder_definition`
SET `json` = JSON_SET(`json`, '$.fieldIDs', JSON_ARRAY(
   "d5afbc83-17dd-4b38-bded-1bf3f4594135",
   "ffdc5c1f-8451-4ed8-b22b-048309d65d44",
   "60065bf3-70b0-4c05-88a6-b9c06277aa29",
   "b957a75d-65aa-427c-a813-63211658649a",
   "147ab095-d8f3-4622-8415-755893d57f40",
   "5b956ab7-5e7b-4471-a377-48e0ec193b05",
   "5c699b8a-3e52-4a95-af17-00a91774d571",
   "b4aead9c-9e97-45bf-a652-f7e979a8f235",
   "fcfbf1ec-294c-43bd-a6c4-044dbe704052",
   "150eeffc-8541-4577-bc59-4b10191e47b1"
))
WHERE `id` = '2ba85be0-78db-4eda-ba43-c2c4e3831849';

/*!40000 ALTER TABLE `appbuilder_definition` ENABLE KEYS */;
UNLOCK TABLES;
