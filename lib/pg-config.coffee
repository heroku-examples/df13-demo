module.exports = ->

  parsedUrl = require("url").parse(process.env.DATABASE_URL || 
    "postgres://localhost/df13-demo")

  config =
    database: parsedUrl.path.replace("/", "")
    host: parsedUrl.hostname

  if parsedUrl.port
    config.port = Number(parsedUrl.port)

  if parsedUrl.auth
    config.user = parsedUrl.auth.split(":")[0]
    config.password = parsedUrl.auth.split(":")[1]

  config.ssl = true unless process.env.NODE_ENV in ["test", "development"]

  config