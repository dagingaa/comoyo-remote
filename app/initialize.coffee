# App Namespace
# Change `ComoyoRemote` to your app's name
@ComoyoRemote ?= {}
ComoyoRemote.Routers ?= {}
ComoyoRemote.Views ?= {}
ComoyoRemote.Models ?= {}
ComoyoRemote.Collections ?= {}
ComoyoRemote.Socket ?= {}

$ ->
    # Load App Helpers
    require '../lib/app_helpers'

# Initialize Device. Move this somewhere... Should only be called when device is set up.

    console.log("Attempting to connect to " + window.location)
    ComoyoRemote.Socket = io.connect(window.location)

    ComoyoRemote.Socket.on "connect", (data) ->
    	console.log "Connected to Socket.IO"
    	$("#statusMessage").html("<p>Connected to Socket.IO</p>")
    	registerUserId("dagingaa@comoyo.com")
    	registerDeviceId("dagingaa@comoyo.com", "browser")

    ComoyoRemote.Socket.on "notification", (data) ->
    	console.log "** NOTIFICATION " + data.message

    ComoyoRemote.Socket.on "playback", (data) ->
    	console.log "** PLAYBACK " + data.movie_id
    	appendVideo("#videoPlayer", data.movie_id)



    # Initialize App
    ComoyoRemote.Views.AppView = new AppView = require 'views/app_view'

    # Initialize Backbone History
    Backbone.history.start pushState: yes


createStreamingUrl = (movieId) ->
	url = "http://frontend.xstream.dk/comoyo/?id=" + movieId

appendVideo = (elementId, movieId) =>
	$(elementId).append("<iframe src='#{createStreamingUrl(movieId)}' width='960' height='600' frameborder='0' allowfullscreen></iframe>")

registerUserId = (userId) =>
	data =
		user_id: userId
	ComoyoRemote.Socket.emit("registerUser", data)

registerDeviceId = (userId, deviceId) =>
	data =
		user_id: userId
		device_id: deviceId
	ComoyoRemote.Socket.emit("addDevice", data)