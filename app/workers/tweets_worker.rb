  # require "clockwork"
  # include Clockwork
class TweetsWorker
  include Sidekiq::Worker
  # include Sidetiq::Schedulable
  sidekiq_options retry: 4

  def perform(options = {})
    Category.lists.each do |category|
      Tweet.list_tweets({count: 20, list: category.list, category_id: category.id })
    end
  end
end

#information -> 2 minutes
#power players 5 min
#DJs 10 min
#scenesters 5 min
#promoters 10 min
