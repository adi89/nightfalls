# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  list       :string(255)
#  state      :string(255)
#

require 'spec_helper'

describe Category do
  before(:each) do
    @category = Fabricate(:category)
  end
  describe '.create' do
    it 'makes a valid tweet' do
      expect(@category.valid?).to eq true
    end
  end
  describe 'scopes' do
    before(:each) do
      @category = Fabricate(:category)
    end
    it 'initializes as low' do
      expect(@category.state).to eq 'low'
    end
    it 'statemachine shifts to high priority' do
      @category.high
      expect(@category.state).to eq 'high'
    end
  end
  describe 'associations' do
    it 'has many tweets' do
      tweet = Tweet.create(tweet_code: "abcd345", text: "sample tweet hello")
      @category.tweets << tweet
      expect(@category.tweets.first).to eq tweet
    end
  end
  describe 'methods' do
    it '#list' do
      expect(Category.list(@category.name)).to eq @category
    end
  end
end
