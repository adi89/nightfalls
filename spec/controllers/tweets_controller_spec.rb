require 'spec_helper'
include Devise::TestHelpers
include ControllerMacros

describe TweetsController do
  before(:each) do
    Fabricate(:tweet)
    @tweets = Tweet.all
    @user = Fabricate(:user)
    @category = Fabricate(:category)
  end

  describe 'get home index' do
    it 'has a 200 status code' do
      login_user(@user)
      get :index
      expect(response.status).to eq 200
    end
  end
  describe 'category page' do
    it 'renders the category page' do
      login_user(@user)
      get :categories, {type: 'high-end-djs'}
      expect(response.status).to eq 200
    end
  end
end