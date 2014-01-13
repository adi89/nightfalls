class UsersController < ApplicationController


def follow
binding.pry
  current_user.friends << Friend.where(username: params['username'])
  Friend.follow_user({username: params['username'], token: current_user.token, token_secret: current_user.token_secret})
  render nothing: true, layout: false
  #there's too much knowledge being passed around.
  #render
end



end