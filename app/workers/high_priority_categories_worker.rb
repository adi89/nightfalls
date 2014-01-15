class HighPriorityCategoriesWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(options = {})
    high_categories = Category.high_priority
    high_categories.each do |category|
      User.list_users_tweets(Tweet, {count: 20, list: category.list, category_id: category.id })
    end
  end
end