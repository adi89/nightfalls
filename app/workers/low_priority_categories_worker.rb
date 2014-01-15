class LowPriorityCategoriesWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(options = {})
   low_categories = Category.low_priority
   low_categories.each do |category|
      User.list_users_tweets(Tweet, {count: 10, list: category.list, category_id: category.id })
    end
  end
end