stylus = require("stylus")
nib = require("nib")

module.exports = stylus.middleware
  src: __dirname + "/styles"
  dest: __dirname + "/public"
  force: true
  debug: true
  compile: (str, path, fn) ->
    stylus(str)
      .set("filename", path)
      .set("compress", true)
      .use(nib())
      .import("nib")
      .render(fn)