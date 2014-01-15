class UsersController < ApplicationController

  def follow
    current_user.friends << Friend.where(username: params['username'])
    Friend.follow_user({username: params['username'], token: current_user.token, token_secret: current_user.token_secret})
    #client follows
    render nothing: true, layout: false
  end

end
