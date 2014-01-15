require "spec_helper"
require 'features/shared/login_helper'
include LoginHelper
include Devise::TestHelpers

describe "Tweets" do
  describe "GET /tweets/index " do
    before(:each) do
      visit root_path
    end
    it 'should have categories upon logging in', js: true do
      login_to_system
      page.should have_link("Categories")
    end
    it 'should have tweets', js: true do
      Fabricate(:tweet).night
      login_to_system
      page.should have_css('.tweet')
    end
  end
  describe 'get /tweets/category', js: true do
    before(:each) do
      @category = Fabricate(:category, list: 'information', name: 'information')
      @tweet = Fabricate(:tweet)
      @category.tweets << @tweet
    end
    it 'should take us to the information page' do
      visit root_path
      login_to_system
      click_link 'Categories'
      click_link 'Information'
      page.should have_content('Information')
    end
    it 'should only show tweets of the information category' do
      Fabricate(:tweet, text: 'test tweet', tweet_code: '123453')
      visit root_path
      login_to_system
      click_link 'Categories'
      click_link 'Information'
      page.should_not have_content('test tweet')
    end
  end
  describe '#follow user' do
    before(:each) do
      @tweet = Fabricate(:tweet, state: 'nightlife')
      Fabricate(:friend, username: @tweet.username)
    end
    it 'should allow us to follow a user', js: true do
      Friend.stub(:unfollow_user).and_return(true)
      visit root_path
      login_to_system
      unless page.has_content?('following')
        page.should have_content 'follow'
        click_link 'follow'
        page.should have_content 'following'
      end
    end
  end
end
