connect = require("connect")
express = require("express")
exphbs = require("express3-handlebars")
db = require("./db")

module.epxorts = app = express()

app.disable "x-powered-by"
app.use connect.urlencoded()
app.use connect.json()
app.use express.static("#{__dirname}/public")
app.use app.router

app.engine "handlebars", exphbs(defaultLayout: "main")
app.set "view engine", "handlebars"

app.get "/", (req, res) ->
  db.getSurvey (survey) ->
    res.render "index", survey

app.get "/survey", (req, res) ->
  db.getSurvey (survey) ->
    res.json survey

app.post "/survey", (req, res) ->
  res.redirect "/"

app.listen process.env.PORT or 5000