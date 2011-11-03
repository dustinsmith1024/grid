Spine = require('spine')

class TList extends Spine.Model
  #@extend Spine.Model.Local

  @configure 'TList', 'name', 'slug', 'tlist_id', 'member_count'

  @get_all: (screen_name, callback) ->
    $.ajax
      url: 'https://api.twitter.com/1/lists.json?screen_name=' + screen_name,
      dataType: 'jsonp',
      success: (data) ->
        console.log 'success'
        console.log data
        for list in data.lists
          console.log list.id, list.name
          l = new TList()
          l.list_id = list.id
          l.slug = list.slug
          l.name = list.name
          l.member_count = list.member_count
          l.save()
  
  @filter: (query) ->
    return @all() unless query
    query = query.toLowerCase()
    @select (item) ->
      item.name?.toLowerCase().indexOf(query) isnt -1

module.exports = TList
