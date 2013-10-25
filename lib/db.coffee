url = require("url")
pg = require("pg")

parsedUrl = url.parse(process.env.DATABASE_URL)

config =
  user: parsedUrl.auth.split(":")[0]
  password: parsedUrl.auth.split(":")[1]
  database: parsedUrl.path.replace("/", "")
  port: Number(parsedUrl.port)
  host: parsedUrl.hostname
  ssl: true

module.exports = getSurveyId: (cb) ->
  pg.connect config, (err, client, done) ->
    throw err if err
    client.query "SELECT id FROM survey__c;", (err, result) ->
      done()
      throw err if err
      cb result.rows[0].id

# client.query("SELECT table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE' AND table_schema NOT IN ('pg_catalog', 'information_schema'); ", function(err, result) {
#   if (err) throw err;
#   console.log(result);
#   done();
# });