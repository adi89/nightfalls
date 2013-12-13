class TweetsWorker
include Sidekiq::Worker
   sidekiq_options retry: 2
   def perform
    Tweet.filter_stream
   end
end
