import path from "path";
import { fileURLToPath } from "url";
import { spawn } from "child_process";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

function command(cmd, options) {
   return new Promise((resolve /*, reject */) => {
      var install = spawn(cmd, options);
      install.stdout.on("data", (data) => {
         console.log(data.toString().trim());
      });
      install.stderr.on("data", (data) => {
         console.log(data.toString().trim());
      });
      install.on("close", (/* code */) => {
         resolve();
      });
      install.on("exit", (/* code */) => {
         resolve();
      });
   });
}

try {
   await import(path.join(__dirname, "app.js"));
} catch (e) {
   var strErr = e.toString();
   var match = strErr.match(/Cannot find module '(.*)'/);
   if (match) {
      var module = match[1];
      console.log(strErr);
      console.log(` ... fixing [${module}]`);
      Promise.resolve()
         .then(() => {
            return command("npm", ["uninstall", module]);
         })
         .then(() => {
            if (module == "ab-utils") {
               module = `hiro-nakamura/ab-utils`;
            }
            return command("npm", ["install", module, "--save"]);
         })
         .then(() => {
            console.log(" ... initializing all dependencies  ");
            return command("npm", ["install", "--force"]);
         })
         .then(() => {
            // setInterval(()=>{ console.log("use cli");}, 10000);
            process.exit();
         });
   } else {
      console.log(e);
      process.exit(1);
   }
}
