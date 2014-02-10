# == Schema Information
#
# Table name: tweets
#
#  id          :integer          not null, primary key
#  username    :string(255)
#  text        :string(255)
#  tweet_code  :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  state       :string(255)
#  category_id :integer
#

require 'spec_helper'

describe Tweet do
  before(:each) do
    @tweet = Fabricate(:tweet)
    @all_tweet_data = Tweet.fetch_all_tweets('mr_adisingh')
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
    it 'sorts by categories' do
      cat = Category.create(name: 'cat1')
      expect(Tweet.category_sort(cat.id).present?).to eq false
    end
  end
  describe 'save tweets' do
    category = Category.create(name: 'ag1')
    it 'saves tweets' do
      tweet = @all_tweet_data.first
      tweet = Tweet.save_tweets(tweet, category_id: category.id)
      expect(tweet).should be_an_instance_of Tweet
    end
  end
  describe 'time methods' do
    it 'scans tweets by minutes' do
      expect(Tweet.tweet_scan(35).first).to eq @tweet
    end
    it 'returns recent tweets (days)' do
      time = Time.now - (60 * 60 * 26)
      t = Fabricate(:tweet, created_at: time, text: 'time sensitive', tweet_code: '7691243')
      expect(Tweet.recent_tweets(1).count).to eq 2
    end
  end
  describe 'validations' do
    it 'must have a unique tweet code' do
      tweet = Tweet.new(tweet_code: @tweet.tweet_code)
      expect(tweet.save).to eq false
    end
  end
  describe 'API' do
    it 'user_timeline_data gives back tweets from a user' do
      expect(@user_timeline_data.present?).to eq true
    end
    it 'fetches all tweets' do
      expect(@all_tweet_data.count).should be > @tweet_data.count
    end
    it 'classifies tweets' do
      tweet_data = @all_tweet_data.first
      Tweet.classify_tweet(tweet_data)
      expect(Tweet.last.text).to eq tweet_data.full_text
    end
    it ' list timeline' do
      timeline = Tweet.list_timeline(list: 'information', count: 20)
      expect(timeline.first).should be_an_instance_of Twitter::Tweet
    end
  end

  describe 'Tweet class methods' do
    it 'sets saves tweet records' do
      t = Tweet.set_tweet_timeline
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
  end
end
