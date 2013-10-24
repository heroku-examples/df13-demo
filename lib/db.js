var url = require('url');
var pg = require('pg');

var parsedUrl = url.parse(process.env.DATABASE_URL)

var config = {
  user: parsedUrl.auth.split(":")[0],
  password: parsedUrl.auth.split(":")[1],
  database: parsedUrl.path.replace("/", ""),
  port: Number(parsedUrl.port),
  host: parsedUrl.hostname,
  ssl: true
}

module.exports = {

  getSurveyId: function(cb) {
    pg.connect(config, function(err, client, done) {
      if (err) throw err;
      client.query("SELECT id FROM survey__c;", function(err, result) {
        done();
        if (err) throw err;
        cb(result.rows[0].id);
      });
    });
  }

}


// client.query("SELECT table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE' AND table_schema NOT IN ('pg_catalog', 'information_schema'); ", function(err, result) {
  //   if (err) throw err;
  //   console.log(result);
  //   done();
  // });