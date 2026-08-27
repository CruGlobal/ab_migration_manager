/**
 * Handler
 * test the interface for our default service handler.
 */
import _ from "lodash";
import { expect } from "chai";
import defaultConfig from "../../config/local.js";
import Handler from "../../src/handler.js";

describe("migration_manager: handler", function () {
   describe("-> missing config", function () {
      it("should return an error when receiving a job request #missingconfig ", function (done) {
         Handler.init(null);
         var request = {};
         Handler.fn(request, (err, response) => {
            expect(err).to.exist;
            expect(err).to.have.property("code", "EMISSINGCONFIG");
            expect(response).to.not.exist;
            done();
         });
      });
   });

   describe("-> disabled ", function () {
      var disabledConfig = _.cloneDeep(defaultConfig);
      disabledConfig.migration_manager.enable = false;

      it("should return an error when receiving a job request #disabled ", function (done) {
         Handler.init({ config: disabledConfig });
         var request = {};
         Handler.fn(request, (err, response) => {
            expect(err).to.have.property("code", "EDISABLED");
            expect(response).to.not.exist;
            done();
         });
      });
   });
});
