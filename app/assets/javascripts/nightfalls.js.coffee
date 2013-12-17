@Tweets =
  incoming: ->
    setTimeout @request, 60000
  request: ->
    console.log('fire!')
    path = $('#tweets').data('url')
    $.get "#{path}?type=stream", (data) ->
      console.log(data)
      $('#tweets').prepend(data)
      $(data).hide().fadeIn('slow')
      Tweets.incoming()
infiniteScroll = (navSelector, itemSelector) ->
  $(navSelector).infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#{navSelector} #{itemSelector}" # selector for all items you'll retrieve
$ ->
  infiniteScroll('#tweets', '.tweet-container')
  if $('#tweets').length > 0
    Tweets.incoming()
