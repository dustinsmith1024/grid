Spine   = require('spine')
TList = require('models/tlist')
Manager = require('spine/lib/manager')
$       = Spine.$

Main    = require('controllers/tweets.main')
Sidebar = require('controllers/lists.sidebar')

class TLists extends Spine.Controller
  className: 'tlists'
  
  constructor: ->
    super
    @log('starting lists controller')
    @sidebar = new Sidebar
    @main    = new Main
    
    @routes
      '/lists/:id/edit': (params) -> 
        @sidebar.active(params)
        @main.edit.active(params)
      '/lists/:id': (params) ->
        @sidebar.active(params)
        @main.show.active(params)
    
    divide = $('<div />').addClass('vdivide')
    
    @append @sidebar, divide, @main
    
    TList.fetch()
    console.log(TList.count())
    if TList.count() is 0
      console.log('fetching lists')
      TList.get_all('dds1024')

module.exports = TLists
