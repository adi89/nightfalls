@Tweets =
  incoming: ->
    setTimeout @request, 300000
  request: ->
    path = $('#tweets').data('url')
    categoryId = $('#tweets').data('category-id')
    $.get "#{path}?type=stream&category_id=#{categoryId}", (data) ->
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

  $('body').on 'click', '.follow-nightlife', (e) ->
    e.preventDefault()
    link = $(this)
    path = link.attr('href')
    username = link.data('username')
    $.get "#{path}?username=#{username}", (data) ->
      link.text('following')
      link.attr('disabled', 'disabled')
#we have tokens from the user and we can pass it along or whatever, we can

#make methods so that we get the list names and make list on another twitteraccount with the same names.