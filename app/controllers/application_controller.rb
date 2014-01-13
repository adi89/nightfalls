class ApplicationController < ActionController::Base
  # require 'sidekiq/testing
  require 'sidekiq'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate
  def authenticate
    @auth = current_user || nil
  end

  def clear_workers
     Sidekiq::Queue.new.clear
  end
end
