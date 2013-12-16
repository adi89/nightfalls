class TweetsWorker
include Sidekiq::Worker
   sidekiq_options retry: false
   def perform
    Tweet.filter_stream
   end
end
