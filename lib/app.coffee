connect = require("connect")
express = require("express")
sanitize = require("validator").sanitize
db = require("./db")

module.exports = app = express()

app.configure ->
  app.disable "x-powered-by"
  app.use connect.urlencoded()
  app.use connect.json()
  app.use app.router
  app.engine "handlebars", require("./handlebars-config")
  app.set "view engine", "handlebars"
  # app.use require('./stylus-config')
  app.use(require('stylus').middleware(__dirname + '/public'));
  app.use '/public/', express.static("public")

app.get "/", (req, res) ->
  db.getAllSurveys (surveys) ->
    res.render "index",
      surveys: surveys
      thanks: req.url.match(/thanks/)

app.get "/schema", (req, res) ->
  db.getSurvey (survey) ->
    res.json survey

app.get "/:survey_id", (req, res) ->
  db.getSurvey req.params.survey_id, (survey) ->
    res.render "survey", survey

app.post "/surveys", (req, res) ->
  db.saveSurvey req.body, (err, survey) ->
    return res.json(500, {error: err}) if err
    # res.json survey
    res.redirect("/?thanks")