Spine   = require('spine')
TList = require('models/tlist')
$       = Spine.$

class Show extends Spine.Controller
  className: 'show'
  
  events:
    'click .edit': 'edit'
  
  constructor: ->
    super
    @active @change
  
  #render: ->
  #  @html require('views/show')(@item)
    
  change: (params) =>
    @item = TList.find(params.id)
    @html 'Loading...' #put a spinner img
    console.log 'render tweets'
    $.ajax
      url: 'https://api.twitter.com/1/lists/statuses.json?slug='+@item.slug+'&owner_screen_name=dds1024&count=1&page=1&include_entities=true',
      dataType: 'jsonp',
      success: (data) =>
        #console.log tweet for tweet in data
        #data.text = @linkify(data.text)
        data = @parse_links(data)
        @html require('views/show_tweets')(data)

    #@item = TList.find(params.id)
    #@render()

  parse_links: (tweets) ->
    for tweet in tweets
      tweet.text = @linkify(tweet.text)
    tweets

  linkify: (text) ->
    exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
    text.replace(exp,"<a href='$1'>$1</a>")

  edit: ->
    @navigate('/lists', @item.id, 'edit')

class Edit extends Spine.Controller
  className: 'edit'
  
  events:
    'submit form': 'submit'
    'click .save': 'submit'
    'click .delete': 'delete'
    
  elements: 
    'form': 'form'
    
  constructor: ->
    super
    @active @change
  
  render: ->
    @html require('views/form')(@item)
    
  change: (params) =>
    @item = TList.find(params.id)
    @render()
    
  submit: (e) ->
    e.preventDefault()
    @item.fromForm(@form).save()
    @navigate('/contacts', @item.id)
    
  delete: ->
    @item.destroy() if confirm('Are you sure?')
    
class Main extends Spine.Stack
  className: 'main stack'
    
  controllers:
    show: Show
    edit: Edit
    
module.exports = Main
