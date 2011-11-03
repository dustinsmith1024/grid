Spine   = require('spine')
TList = require('models/tlist')
List    = require('lib/list')
$       = Spine.$

class Sidebar extends Spine.Controller
  className: 'sidebar'
    
  elements:
    '.items': 'items'
    'input': 'search'
    
  events:
    'keyup input': 'filter'
    'click footer button': 'create'
  
  constructor: ->
    super
    @html require('views/sidebar')()
    
    @list = new List
      el: @items, 
      template: require('views/item'), 
      selectFirst: true

    @list.bind 'change', @change

    @active (params) -> 
      @list.change(TList.find(params.id))
    
    TList.bind('refresh change', @render)
  
  filter: ->
    @query = @search.val()
    @render()
    
  render: =>
    lists = TList.filter(@query)
    @list.render(lists)
    
  change: (item) =>
    @navigate '/lists', item.id
 
  create: ->
    item = TList.create()
    @navigate('/lists', item.id, 'edit')
    
module.exports = Sidebar
