module TwitterClient
  extend ActiveSupport::Concern

    module ClassMethods
      def client
        Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
          config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
          config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
          config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
        end
      end

      def home_timeline_data
        client.home_timeline(:count => 200)
      end

      def user_timeline_data(user, options)
        client.user_timeline(user, options)
      end

      def collect_with_max_id(collection=[], max_id=nil, &block)
        response = yield max_id
        collection += response
        response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
      end

      def fetch_all_tweets
        collect_with_max_id do |max_id|
          options = {:count => 200, :include_rts => true}
          options[:max_id] = max_id unless max_id.nil?
          user_timeline_data('mr_adisingh', options)
        end
      end
    end

end
