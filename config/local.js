/*
 * migration_manager
 */
const AB = require("@digiserve/ab-utils");

module.exports = {
   migration_manager: {
      /*************************************************************************/
      /* enable: {bool} is this service active?                                */
      /*************************************************************************/
      enable: true,
   },

   /**
    * datastores:
    * Sails style DB connection settings
    */
   datastores: AB.defaults.datastores(),
};
