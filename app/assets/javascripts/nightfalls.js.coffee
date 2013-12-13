@Tweets =
  incoming: ->
    setTimeout @request, 60000
  request: ->
    console.log('fire!')
    path = $('#tweets').data('url')
    $.get path, (data) ->
      console.log(data)
      $('#tweets').prepend(data)
      Tweets.incoming()

$ ->
  if $('#tweets').length > 0
    Tweets.incoming()