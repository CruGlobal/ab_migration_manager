/*
 * migration_manager
 */
import AB from "@digiserve/ab-utils";

export default {
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
