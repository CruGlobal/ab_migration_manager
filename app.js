//
// migration_manager
// (AppBuilder) A service to apply DB migrations to a running site.
// Our one task is to query the DB and find the Tenants
// For each Tenant:
//		Find what the latest patch that was applied
//		scan the patches directory for any additional patches and apply them
// 		update the DB to the latest patch.
//
// then we are done.
//
//
// TODO: Possible Improvement:
// convert patch files to .js files.
// patch.js = {
//  do: async ( req ) => {
//    run some js commands;
//    req.queryIsolate( this.sql1 ...);
//    do some work on DB
//    req.queryIsolate( this.sql2 ...);
//
//  },
//  sql1: ` SQL STATEMENTS HERE `,
//  sql2: ` MORE SQL STATEMENTS `,
// }
//
const fs = require("fs");
const path = require("path");
const process = require("process");

const AB = require("@digiserve/ab-utils");

const Mysql = require("mysql"); // our  {DB Connection}
const config = require(path.join(__dirname, "config", "local.js"));
// {json}
// our current set of configuration options for connecting to our DB

const DB = Mysql.createConnection(config.datastores.site);
DB.on("error", (err) => {
   tLog("DB.on(error):", err);

   // format of err:
   // {
   //   Error: "read ECONNRESET at TCP.onStreamRead (internal/stream_base_commons.js:162:27)",
   //   errno: 'ECONNRESET',
   //   code: 'ECONNRESET',
   //   syscall: 'read',
   //   fatal: true
   // }

   DB.end();
});

const patchFiles = [];
// {array} [ file1.sql, ... fileN.sql ]
// a list of the patch files in our patches directory.

const Tenants = [];
// {array} [ tenantID1, ... tenantIDN ]
// a list of the returned tenants in our site.

////
//// Helper fn()s
////

/**
 * @function log()
 * This is a throttled logger. It will only display a message every lim times.
 * @param {string} msg
 *        The message to log.
 * @param {int} lim
 *        The number of times to delay the message.
 */
var displayCount = 0;
function log(msg, lim) {
   displayCount += 1;
   if (displayCount > lim) {
      displayCount = 0;
   }

   if (displayCount == lim) {
      console.log(msg);
   }
}

function mockReq(tenantID = "??") {
   return {
      tenantID,
   };
}

function mockController() {
   return {
      config,
      connections: config.datastores,
   };
}

////
//// Process Steps
////

/**
 * @function Connect()
 * Establish a connection to our Maria DB instance.
 * This will retry until it is able to connect.
 * @return {Promise}
 */
function Connect() {
   return new Promise((resolve, reject) => {
      DB.connect(function (err) {
         if (err) {
            log("mysql not ready ... waiting.", 3);
            setTimeout(() => {
               Connect().then(() => {
                  resolve();
               });
            }, 500);
            return;
         }
         console.log("successful connection to mysql, continuing");
         resolve();
      });
   });
}

/**
 * @function ReadTenants()
 * Read in the Tenant information from the admin db.
 * @return {Promise}
 */
function ReadTenants() {
   return new Promise((resolve, reject) => {
      let req = new AB.reqService(mockReq(), mockController());

      let tenantDB = "`appbuilder-admin`";
      // {string} tenantDB
      // the DB name of the administrative tenant that manages the other
      // tenants.
      // By default it is `appbuilder-admin` but this value can be over
      // ridden in the  req.connections().site.database  setting.

      let conn = req.connections();
      if (conn.site?.database)
         tenantDB = `\`${conn.site.database}\``;
      tenantDB += ".";

      let sql = `SELECT * FROM ${tenantDB}\`site_tenant\` `;

      req.query(sql, [], (error, results, fields) => {
         if (error) {
            req.log(sql);
            reject(error);
         } else {
            // return an array of their .uuids
            resolve(results.map((t) => t.uuid));
         }
      });
   });
}

function tenantUseDB(req) {
   return new Promise((resolve, reject) => {
      let sql = `use ${req.tenantDB()};`;
      req.queryIsolate(sql, [], (e, r, f) => {
         if (e) {
            reject(e);
            return;
         }
         resolve();
      });
   });
}

function tenantPullLastPatch(req) {
   return new Promise((resolve, reject) => {
      let sql =
         'SELECT * FROM `SITE_CONFIG` WHERE `key` = "migration-last-patch";';
      req.queryIsolate(sql, [], (err, results /*, fields */) => {
         if (err) {
            if (err.code == "ER_NO_SUCH_TABLE") {
               // this is the 1st time to run this migration tool.
               // so just return "" and our initial sql will be picked up and
               // run.
               resolve("");
               return;
            }
            console.log(err);
            reject(err);
            return;
         }
         resolve(results[0].value);
      });
   });
}

function doCommand(list, req, cb) {
   if (list.length == 0) {
      cb();
   } else {
      let command = list.shift();
      if (command == "" || command == "\n") {
         doCommand(list, req, cb);
         return;
      }
      // console.log(command);
      req.queryIsolate(command, [], (err, results) => {
         if (err) {
            err.sql = command;
            cb(err);
            return;
         }
         doCommand(list, req, cb);
      });
   }
}

function tenantProcessPatch(req, fileName) {
   return new Promise((resolve, reject) => {
      let filePath = path.join(__dirname, "patches", fileName);
      let contents = fs.readFileSync(filePath, { encoding: "utf8" });
      let commands = contents.split(";");
      doCommand(commands, req, (err) => {
         if (err) {
            reject(err);
            return;
         }
         resolve();
      });
   });
}

function tenantPostLastPatch(req, lastPatch) {
   return new Promise((resolve, reject) => {
      let sql =
         'UPDATE `SITE_CONFIG` SET `value` = ? WHERE `key` = "migration-last-patch";';
      req.queryIsolate(sql, [lastPatch], (err, results /*, fields */) => {
         if (err) {
            console.log(err);
            reject(err);
            return;
         }
         resolve();
      });
   });
}

function tLog(id, msg) {
   console.log(`   [${id}]: ${msg}`);
}

async function ProcessTenant(id) {
   let tenantReq = new AB.reqService(mockReq(id), mockController());
   try {
      await tenantUseDB(tenantReq);
      let lastPatch = await tenantPullLastPatch(tenantReq);
      let currPatch = lastPatch;
      tLog(id, `last patch = "${lastPatch || "none"}"`);

      // foreach file:
      for (var f = 0; f < patchFiles.length; f++) {
         let patch = patchFiles[f];
         if (lastPatch < patch) {
            await tenantProcessPatch(tenantReq, patch);
            tLog(id, `updated to patch ${patch}`);
            lastPatch = patch;
         }
      }

      // update the lastPatch entry if it has changed.
      if (currPatch != lastPatch) {
         await tenantPostLastPatch(tenantReq, lastPatch);
      }
      tenantReq.queryIsolateClose();
      tLog(id, "tenant migration complete.");
   } catch (e) {
      console.error(`   [${id}] Error processing Tenant`);
      console.error(e);
      if (e.sql) {
         console.error(e.sql);
      }
      tenantReq.queryIsolateClose();
   }
}

/**
 * @function pullPatchFiles()
 * Read in the patch files.
 * @return {Promise}
 */
async function PullPatchFiles() {
   var ignoreFiles = [];
   var patchDir = path.join(__dirname, "patches");
   var entries = fs.readdirSync(patchDir);
   entries.forEach((e) => {
      // don't list the api_sails service.
      if (ignoreFiles.indexOf(e) > -1) {
         return;
      }
      var stats = fs.statSync(path.join(patchDir, e));
      if (stats.isFile()) {
         // patch files are in format: yyyymmdd.sql
         // we just want the yyyymmdd :
         patchFiles.push(e);
      }
   });
}

//
// Now we just wait to be closed out when the docker stack is removed.
function wait() {
   // console.log(".");
}

async function Do() {
   try {
      await PullPatchFiles();
      await Connect();
      let tenantIDs = await ReadTenants();
      console.log(`${tenantIDs.length} tenants to process.`);

      let allUpdates = [];
      tenantIDs.forEach((tID) => {
         allUpdates.push(ProcessTenant(tID));
      });

      await Promise.all(allUpdates);

      DB.destroy();
      console.log("... all migrations have been performed.");
      // setInterval(wait, 10000);
      process.exit();
   } catch (e) {
      console.error("!Unable to perform migration:");
      console.error(e);
   }
}
Do();
