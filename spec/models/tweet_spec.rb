# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  username   :string(255)
#  text       :string(255)
#  tweet_code :string(255)
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)
#

require 'spec_helper'

describe Tweet do
  before(:each) do
    @tweet = Fabricate(:tweet)
    @all_tweet_data = Tweet.fetch_all_tweets
    @user_timeline_data = Tweet.user_timeline_data('mr_adisingh', {})
    Tweet.stub(:fetch_all_tweets).and_return @all_tweet_data
    @tweet_data = Tweet.user_timeline_data('mr_adisingh', {})
  end
  describe '.create' do
    it 'makes a valid tweet' do
      expect(@tweet.valid?).to eq true
    end
  end
  describe 'state machine' do
    it 'initializes as irrelevant' do
      expect(@tweet.state).to eq 'irrelevant'
    end
    it 'classifies as nightlife' do
      @tweet.night
      expect(@tweet.state).to eq "nightlife"
    end
  end
  describe 'scopes' do
    it 'filters by nightlife state' do
      expect(Tweet.nightlife.present?).to eq false
    end
    it 'filters by irrelevant state' do
      expect(Tweet.irrelevant.present?).to eq true
    end
  end
  describe 'validations' do
    it 'must have a unique tweet code' do
      tweet = Tweet.new(tweet_code: @tweet.tweet_code)
      expect(tweet.save).to eq false
    end
  end
  describe 'TwitterClient' do
    it 'client' do
      expect(Tweet.client.present?).to eq true
    end
    it 'user_timeline_data gives back tweets from a user' do
      expect(@user_timeline_data.present?).to eq true
    end
    it 'fetches all tweets' do
      expect(@all_tweet_data.count).should be > @tweet_data.count
    end
  end
  describe 'Tweet class methods' do
    it 'sets saves tweet records' do
      Tweet.set_tweet_timeline
      expect(Tweet.all.count).should be > 1
    end
    it 'tweets #hashify' do
      @tweet = Tweet.hashify(@tweet)
      expect(@tweet.class).to eq Hash
    end
    it 'parses the hash by attribute' do
      text = Tweet.parse_hash(@tweet, 'text')
      expect(text).to eq @tweet.text
    end
    it 'collects string from active record collection' do
      nightlife = Tweet.irrelevant
      expect(Tweet.collect_strings(nightlife).first.class).to eq String
    end
  end
end
