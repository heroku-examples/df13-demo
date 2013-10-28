location = require('geolocation-stream')()

location.on "data", (position) ->
  console.log position
  document.querySelector("#latitude").value = position.coords.latitude
  document.querySelector("#longitude").value = position.coords.longitude

location.on "error", (err) ->
  console.error "geolocation error", err