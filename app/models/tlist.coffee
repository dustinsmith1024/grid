Spine = require('spine')

class TList extends Spine.Model
  @configure 'TList', 'img', 'name', 'slug', 'tlist_id', 'member_count'
  @extend Spine.Model.Local

  @get_all: (screen_name, callback) ->
    TList.deleteAll()
    $.ajax
      url: 'https://api.twitter.com/1/lists.json?screen_name=' + screen_name,
      dataType: 'jsonp',
      success: (data) ->
        for list in data.lists
          console.log list.id, list.name
          l = new TList()
          l.list_id = list.id
          l.slug = list.slug
          l.name = list.name
          l.member_count = list.member_count
          l.save()
          l.getImage()

  getImage: ->
    list = @
    $.getJSON "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=cca4e5c768a106ef85d2a19e22f8222d&tags="+@name+"&per_page=1&page=1&format=json&nojsoncallback=1", (data) ->
      if data.photos.pages is 0
        list.img = "question_mark.jpg"
        list.save()
      else
        id = data.photos.photo[0].id
        $.getJSON "http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=cca4e5c768a106ef85d2a19e22f8222d&photo_id=" + id + "&format=json&nojsoncallback=1", (photo) ->
          list.img = photo.sizes.size[0].source
          console.log "image", list.img
          list.save()

  
  @filter: (query) ->
    return @all() unless query
    query = query.toLowerCase()
    @select (item) ->
      item.name?.toLowerCase().indexOf(query) isnt -1

module.exports = TList
