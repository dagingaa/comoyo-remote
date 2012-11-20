View = require '../lib/view'

module.exports = class AppView extends View
    el: 'body.application'

    initialize: ->
        @router = ComoyoRemote.Routers.AppRouter = new AppRouter = require '../routers/app_router'
