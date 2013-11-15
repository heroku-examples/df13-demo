module.exports = ->

  parsedUrl = require("url").parse(process.env.DATABASE_URL || 
    "postgres://localhost/df13-demo")
    "postgres://ufeuae9i5ee9ql:p446uvrie1nvoqjq03627eit56@ec2-54-204-14-133.compute-1.amazonaws.com:5432/d44imojpvm7lbt"
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