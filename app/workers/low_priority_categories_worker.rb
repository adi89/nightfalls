class LowPriorityCategoriesWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(options = {})
   low_categories = Category.low_priority
   low_categories.each do |category|
      Tweet.list_users_tweets({count: 10, list: category.list, category_id: category.id })
    end
  end
end