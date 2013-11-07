window.geo = require('geolocation-stream')()
window.domready = require('domready')

domready ->

  # Animate all content
  [].forEach.call document.querySelectorAll("#content li"), (element) ->
    element.classList.add('active')

  # Append geodata to hidden form fields
  if document.querySelector("#latitude")

    geo.on "data", (position) ->
      console.log position
      document.querySelector("#latitude").value = position.coords.latitude
      document.querySelector("#longitude").value = position.coords.longitude

    geo.on "error", (err) ->
      console.error "geolocation error", err