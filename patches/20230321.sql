# ************************************************************
# 20230321.sql
# 
# This patch adds the scopeQuery column on SITE_PROCESS_FORM.
# ************************************************************

#
# 1) Insert the scopeQuery column on SITE_PROCESS_FORM
#

LOCK TABLES `SITE_PROCESS_FORM` WRITE;
ALTER TABLE `SITE_PROCESS_FORM` ADD COLUMN IF NOT EXISTS `scopeQuery` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`scopeQuery`));
UNLOCK TABLES;

#
# 2) Add site definitions for system objects.
#
LOCK TABLES `appbuilder_definition` WRITE;
INSERT IGNORE INTO `appbuilder_definition` (`id`, `name`, `type`, `json`, `createdAt`, `updatedAt`) 
VALUES
  ('eddb2e90-e41c-4b6b-a93b-9f3c4ca05637', 'ProcessForm->scopeQuery', 'field', '{"id":"eddb2e90-e41c-4b6b-a93b-9f3c4ca05637","type":"field","key":"json","icon":"font","isImported":0,"columnName":"scopeQuery","settings":{"showIcon":1,"required":0,"unique":0,"validationRules":"[]","width":140},"translations":[{"language_code":"en","label":"scopeQuery"}]}', '2023-03-20 09:33:07', '2023-03-20 09:33:07');
UPDATE `appbuilder_definition`
SET `json` = '{"id":"d36ae4c8-edef-48d8-bd9c-79a0edcaa067","type":"object","name":"ProcessForm","labelFormat":"","labelSettings":{"isNoLabelDisplay":0},"isImported":0,"isExternal":0,"tableName":"SITE_PROCESS_FORM","primaryColumnName":"uuid","transColumnName":"","urlPath":"","objectWorkspace":{"frozenColumnID":"","sortFields":[],"filterConditions":[],"hiddenFields":[]},"isSystemObject":1,"translations":[{"language_code":"en","label":"ProcessForm"}],"fieldIDs":["5d3d1809-8914-4d30-87a5-3a98183e2210","3b1aa34c-3d6b-4c52-bc9f-36d3b83a430d","457f0c51-34d7-4906-8a17-0a135a6ad28d","1bb5858f-b5bd-4ca6-889e-863d83eb5c42","f130bb15-aaf2-470c-a355-ba93b8f1f169","2ad73d00-1b0a-4c08-b87b-e1541cd5a4c1","c75a42b2-e764-495c-8a16-d090c2a7a6b3","5ec29c7f-6546-4e27-a3a3-c4235e9d1a38","b2b51ef4-b6ce-4a3c-a1a1-365274bee276","c6be3644-8af5-4150-8f3e-52337f5f2a75","eddb2e90-e41c-4b6b-a93b-9f3c4ca05637"],"importedFieldIDs":[],"indexIDs":[],"createdInAppID":"227bcbb3-437f-4bb5-a5a1-ec3198696206","objectWorkspaceViews":{"currentViewID":"1a5f3fd7-65d7-4263-9cb8-96b97596a509","list":[{"id":"1a5f3fd7-65d7-4263-9cb8-96b97596a509","translations":[{"language_code":"en","label":"grid"}],"isDefaultView":true,"name":"Default Grid","sortFields":[],"filterConditions":[],"frozenColumnID":"","hiddenFields":[],"type":"grid"}]}}'
WHERE `id` = 'd36ae4c8-edef-48d8-bd9c-79a0edcaa067';
UNLOCK TABLES;
