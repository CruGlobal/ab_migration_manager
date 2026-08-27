/**
 * Stub handler for migration_manager (service has no cote handler; used for unit tests).
 */
var config;

export default {
   init: function (options) {
      options = options || {};
      config = options.config || null;
   },

   fn: function handler(req, cb) {
      if (!config) {
         const err = new Error("migration_manager: Missing config");
         err.code = "EMISSINGCONFIG";
         err.req = req;
         cb(err);
         return;
      }
      if (!config.migration_manager?.enable) {
         const err = new Error("migration_manager service is disabled.");
         err.code = "EDISABLED";
         cb(err);
         return;
      }
      cb(null, {});
   },
};
