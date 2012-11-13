$(document).ready =>
	console.log("Attempting to connect to " + window.location)
	@socket = io.connect(window.location)

	@socket.on "connect", (data) ->
		console.log "Connected to Socket.IO"
		$("#statusMessage").html("<p>Connected to Socket.IO</p>")
		registerUserId("dagingaa@comoyo.com")
		registerDeviceId("dagingaa@comoyo.com", "browser")

	@socket.on "notification", (data) ->
		console.log "** NOTIFICATION " + data.message

	@socket.on "playback", (data) ->
		console.log "** PLAYBACK " + data.movie_id
		appendVideo("#videoPlayer", data.movie_id)


	# appendVideo("#videoPlayer")

createStreamingUrl = (movieId) ->
	url = "http://stage-frontend.xstream.dk/comoyo/?id=" + movieId

appendVideo = (elementId, movieId) =>
	$(elementId).append("<iframe src='#{createStreamingUrl(movieId)}' width='960' height='600' frameborder='0' allowfullscreen></iframe>")

registerUserId = (userId) =>
	data =
		user_id: userId
	window.socket.emit("registerUser", data)

registerDeviceId = (userId, deviceId) =>
	data =
		user_id: userId
		device_id: deviceId
	window.socket.emit("addDevice", data)