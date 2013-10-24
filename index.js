var db = require("./lib/db");

db.getSurveyId(function(id) {
  console.log("getSurveyId", id);
})