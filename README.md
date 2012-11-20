Comoyo Remote
===============

A remote for Comoyo Film using Node.JS, Express.JS, Socket.IO, Coffeescript,
Brunch, Backbone.js Bootstrap and many other cool new-agy things.

It basicly allows for registering a device to a user, and will (eventuelly)
enable a GUI for starting playback on any given divice for any given user.

It works by leveraging socket.io for the command pushing, using a REST-based
approach for the remote control. When the device recieves a playback command
an iframe is appended that points to the silverlight player.

It is currently limited by some factors such as you needing a keyboard anyway,
but a cool tech demo nonetheless.

Brunch Automatic Building
=========================

This project uses [brunch.io](http://brunch.io) to automatically build the
project and refresh the browser upon changes. Brunch can automatically minify
the project before releasing to production, nad automatically concatenates all
files for you.

Requirements
=============
- Node.js: http://howtonode.org/how-to-install-nodejs
- Node Packet Manager
- Brunch
- CoffeeScript

Setup
======
1. Make sure you have npm and node installed. 
2. Run `npm install -g brunch`
3. Run `npm install` in the root of the project



Using
=====
- Run `brunch -w`
- Run `coffee remote_server.coffee` from the root directory
- Open http://localhost:4545 in a modern browser
- To start playback, enter [http://localhost:4545/dagingaa@comoyo.com/browser/playback/1837142](http://localhost:4545/dagingaa@comoyo.com/browser/playback/1837142) in another window.

Thanks
======
Thanks to Jonas and Bruun for their helpful node.js and socket.io guide.

TODO
======
- Add GUI for Remote
- Integrate James API
- Get list of devices from server for a given user

