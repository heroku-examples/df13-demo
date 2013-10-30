connect = require("connect")
express = require("express")
sanitize = require("validator").sanitize
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

  # Watch out for XSS
  for key, value of req.body
    req.body[key] = sanitize(value).xss() unless typeof(value) is "object"

  for key, value of req.body.questions
    req.body.questions[key] = sanitize(value).xss()

  db.saveSurvey req.body, (err, survey) ->
    return res.json(500, {error: err}) if err
    res.json survey