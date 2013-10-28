connect = require("connect")
express = require("express")
db = require("./db")

module.exports = app = express()

app.configure ->
  app.disable "x-powered-by"
  app.use connect.urlencoded()
  app.use connect.json()
  app.use '/public/', express.static("public")
  app.use app.router
  app.engine "handlebars", require("./handlebars-config")
  app.set "view engine", "handlebars"

app.get "/", (req, res) ->
  db.getSurvey (survey) ->
    res.render "index", survey

app.get "/survey", (req, res) ->
  db.getSurvey (survey) ->
    res.json survey

app.post "/survey", (req, res) ->
  res.redirect "/"