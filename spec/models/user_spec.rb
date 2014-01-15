# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  provider               :string(255)
#  uid                    :string(255)
#  username               :string(255)
#  token                  :string(255)
#  token_secret           :string(255)
#

require 'spec_helper'

describe User do
  describe 'list user tweets' do
    it 'iterates through users and saves tweets' do
      user = Fabricate(:user)
      t =  User.list_users_tweets(Tweet, {list: 'information', token: user.token, token: user.token_secret})
      expect(t.first).should be_an_instance_of Twitter::Tweet
    end
  end
end
