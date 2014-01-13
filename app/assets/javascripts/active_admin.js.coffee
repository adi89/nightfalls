#= require active_admin/base
#= require jquery
#= require jquery_ujs
#= require jquery.ui.all

$ ->
  $('.tweet-admin-state').click (e) ->
    e.preventDefault()
    tweet = $(this)
    state = $(this).text()
    path = $(this).attr('href')
    id = $(this).data('id')
    $.get "/admin/tweets/state?state=#{state}&id=#{id}", (data) ->
      console.log(data.state)
      tweet.text(data.state)
