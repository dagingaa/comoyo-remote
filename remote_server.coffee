clean = require("validator").sanitize
express = require("express")
app = express()
http = require("http")
server = http.createServer(app)

Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

class User
	constructor: ->
		@devices = new Array()

	addDevice: (deviceId, socket) ->
		@devices[deviceId] = new Device(socket) if not @isDeviceAdded(deviceId)

	removeDevice: (deviceId) ->
		@devices.remove(deviceId)

	isDeviceAdded: (deviceId) ->
		deviceId in @devices

class Device 
	constructor: (@socket) ->

	getSocket: ->
		return @socket

users = new Array()

# Configure the express.js framework
app.configure ->
	app.use("/assets", express.static(__dirname + "/assets"))


# Initialize routes
app.get("/", (req,res) ->
	res.sendfile(__dirname + "/assets/index.html")
)

app.get("/:user/:device/playback/:movie", (req,res) ->
	userId = req.params.user
	deviceId = req.params.device
	movieId = req.params.movie

	# Validate userId present in remote database
	if getUser(userId) == undefined
		res.send("No user found")
		return

	user = getUser(userId)

	# Validate deviceId present for user
	if user.devices[deviceId] == undefined
		res.send("No device found for user")
		return

	device = user.devices[deviceId]

	socket = device.getSocket()

	if socket == undefined
		res.send("Connection lost to device")
		user.removeDevice(deviceId)
		return

	console.log("Playback event for #{userId} on #{deviceId} for movie #{movieId}")
	socket.emit("playback", movie_id: movieId)
	res.send("Playback started")

)

server.listen 4545
console.log "HTTP server running at http://0.0.0.0:4545"

# Initialize socket.io interface
io = require("socket.io").listen(server)
io.set("transports", ["xhr-polling"])
io.set("polling duration", 10) 

# Handle client connection
io.sockets.on "connection", (socket) ->
	socket.emit("notification", message: "Connection successfull")

	# Registers the user for this socket
	socket.on "registerUser", (data) ->
		# This should really be changed to talk to Idee or something.
		userId = clean(data.user_id).xss()
		socket.set("user_id", userId)
		addUser(userId)
		socket.emit("notification", message: "User registered")

	socket.on "addDevice", (data) ->
		userId = clean(data.user_id).xss()
		deviceId = clean(data.device_id).xss()
		addDeviceToUser(userId, deviceId, socket)
		socket.emit("notification", message: "Device registered")

addUser = (userId, socket) =>
	if users[userId] == undefined
		users[userId] = new User()
	return users[userId]

addDeviceToUser = (userId, deviceId, socket) =>
	getUser(userId).addDevice(deviceId, socket)

getUser = (userId) ->
	return users[userId]