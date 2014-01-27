@Tweets =
  getTweetIds: (tweetArray) ->
    $.map tweetArray, (a) ->
      return $(a).data('tweet-id')
  arrayToString: (tweetArray) ->
    tweets = Tweets.getTweetIds(tweetArray)
    str = ""
    i = 0
    while i < $(tweets).length
      str += "," + (tweets[i])
      i++
    str = str.substring(1)
  incoming: ->
    setTimeout @request, 300000
  request: ->
    path = $('#tweets').data('url')
    tweetArray = $('#tweets .tweet')
    categoryId = $('#tweets').data('category-id')
    str = Tweets.arrayToString(tweetArray)
    $.get "#{path}?type=stream&category_id=#{categoryId}&str=#{str}", (data) ->
      $('#tweets').prepend(data)
      $(data).hide().fadeIn('slow')
      Tweets.incoming()
infiniteScroll = (navSelector, itemSelector) ->
  $(navSelector).infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#{navSelector} #{itemSelector}" # selector for all items you'll retrieve
$ ->
  infiniteScroll('#tweets', '.tweet')
  if $('#tweets').length > 0
    Tweets.incoming()
  $('body').on 'click', '.follow-nightlife', (e) ->
    e.preventDefault()
    link = $(this)
    path = link.attr('href')
    username = link.data('username')
    $.get "#{path}?username=#{username}", (data) ->
      link.parent().parent().removeClass('btn btn-success')
      link.text('following')
      link.attr('disabled', 'disabled')
  $('#flash_notice').fadeOut(1600)
  $('.cat-title').hide().fadeIn('slow')