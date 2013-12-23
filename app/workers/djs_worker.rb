class DjsWorker
  include Sidekiq::Worker
  # include Sidetiq::Schedulable
  sidekiq_options retry: 4

  def perform(options = {})
    category = Category.list('high end djs')
      Tweet.list_tweets({count: 20, list: category.list, category_id: category.id })
    end
  end
