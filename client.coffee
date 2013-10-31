document.addEventListener 'DOMContentLoaded', ->

  window.geo = require('geolocation-stream')()

  if document.querySelector("#latitude")

    geo.on "data", (position) ->
      console.log position
      document.querySelector("#latitude").value = position.coords.latitude
      document.querySelector("#longitude").value = position.coords.longitude

    geo.on "error", (err) ->
      console.error "geolocation error", err