require('lib/setup')

Spine = require('spine')
TLists = require('controllers/lists')

class App extends Spine.Controller
  constructor: ->
    super
    @log("Initialized")

    @lists = new TLists
    @append @lists.active()

    Spine.Route.setup()
   
module.exports = App
    
