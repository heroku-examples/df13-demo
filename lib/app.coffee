connect = require("connect")
express = require("express")
db = require("./db")

module.exports = app = express()

app.configure ->
  app.disable "x-powered-by"
  app.use connect.urlencoded()
  app.use connect.json()
  app.use app.router
  app.engine "handlebars", require("./handlebars-config")
  app.set "view engine", "handlebars"
  app.use '/public/', express.static("public")

app.get "/", (req, res) ->
  db.getAllOpinions (opinions) ->
    res.render "index",
      opinions: opinions
      thanks: req.url.match(/thanks/)

app.get "/schema", (req, res) ->
  db.getAllOpinions (opinions) ->
    db.getOpinions opinions[0].sfid, (opinion) ->
      res.json survey

app.post "/opinions", (req, res) ->
  db.saveOpinion req.body, (err, opinion) ->
    return res.json(500, {error: err}) if err
    # res.json opinion
    res.redirect("/?thanks")

app.get "/opinions/:opinion_id", (req, res) ->
  db.getOpinion req.params.opinion_id, (opinion) ->
    res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate")
    res.setHeader("Pragma", "no-cache")
    res.setHeader("Expires", "0")
    res.render "opinion", opinion