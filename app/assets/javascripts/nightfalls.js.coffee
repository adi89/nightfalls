@Tweets =
  incoming: ->
    setTimeout @request, 60000
  request: ->
    console.log('fire!')
    path = $('#tweets').data('url')
    $.get "#{path}?type=stream", (data) ->
      console.log(data)
      $('#tweets').prepend(data)
      Tweets.incoming()

$ ->
  if $('#tweets').length > 0
    Tweets.incoming()

  $("#tweets").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#tweets .tweet-container" # selector for all items you'll retrieve