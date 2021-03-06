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

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  attr_accessor :current_user
  has_many :users_friends
  has_many :friends, through: :users_friends
  after_save  {|user| user.rack_up_friends}

  def self.from_omniauth(auth)
    user_query = where(auth.slice(:provider, :uid))
    if user_query.present?
      user_query.first.save
      user_query.first
    else
      user_query.create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.token = auth.extra['access_token'].token
        user.token_secret = auth.extra['access_token'].secret
        user.username = auth.info.nickname
      end
    end
  end

  def self.list_users_tweets(receiver, options = {})
    user = self.all.sample
    receiver.list_tweets(options.merge(token: user.token, token_secret: user.token_secret))
  end

  def following?(tweet_handle)
    self.friends.where(username: tweet_handle).present?
  end

  def rack_up_friends
      self.friends << Friend.save_friends(options)
  end

  def options
    {token: self.token, token_secret: self.token_secret}
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

end
