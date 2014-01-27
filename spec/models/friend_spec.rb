# == Schema Information
#
# Table name: friends
#
#  id          :integer          not null, primary key
#  username    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  profile_pic :string(255)
#

require 'spec_helper'

describe Friend do
  before(:each) do
    @friend = Fabricate(:friend)
  end
  describe '.create' do
    it 'creates an instance of friend' do
      expect(@friend.valid?).to eq true
    end
  end
  describe 'associations' do
    it 'has/belongs to many users' do
      user = Fabricate(:user)
      @friend.users << user
      expect(@friend.users.present?).to eq true
    end
  end
  describe 'validations' do
    it 'validates the uniqueness of a username' do
      f= Friend.new(username: @friend.username)
      expect(f.save).to eq false
    end
  end
  describe 'module' do
    it 'has twitter client included' do
      expect(Friend.client.present?).to eq true
    end
  end
end
