connect = require("connect")
express = require("express")
jade = require("jade")
db = require("./db")

module.epxorts = app = express()

app.disable "x-powered-by"
app.use connect.urlencoded()
app.use connect.json()
app.use express.static("#{__dirname}/public")
app.use app.router

app.get "/", (req, res) ->
  # res.send "ok"
  db.getSurveyId (id) ->
    # console.log "getSurveyId", id
    # res.send "#{id}"
    res.render "index.jade", id:id

app.post "/surveys", (req, res) ->
  res.redirect "/"

app.listen process.env.PORT or 5000