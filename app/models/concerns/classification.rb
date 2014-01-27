module Classification
  extend ActiveSupport::Concern
  include API

  module ClassMethods
    def list_tweets(options = {})
      list_tweets_parse(options).each do |tweet|
        if nightlife?(tweet)
          options[:state] = 'nightlife'
          save_tweets(tweet, options)
        else
          options[:state] = 'irrelevant'
          save_tweets(tweet, options)
        end
      end
    end

    def collect_strings(collection)
      collection.map!{|tweet| corpse_string(tweet, 'text')}
    end

    def corpse_string(tweet, attribute)
      hash = Hash.new
      hash[attribute] = parse_hash(tweet, attribute)
      hash[attribute]
    end

    def parse_hash(tweet, attribute)
      hashify(tweet)[attribute]
    end

    def hashify(tweet)
      JSON.load(tweet.to_json)
    end

    def nightlife?(tweet_data)
      classifier = StuffClassifier::Bayes.open("night or discard")
      if classifier.category_list.empty?
        classify_init(classifier)
      end
      classifier.classify(tweet_data.full_text) == :night
    end

    def classify_init(classifier)
      irrelevant = Tweet.collect_strings(Tweet.irrelevant)
      nightlife = Tweet.collect_strings(Tweet.nightlife)
      nightlife.each do |tweet|
        classifier.train(:night, tweet)
      end
      irrelevant.each do |tweet|
        classifier.train(:discard, tweet)
      end
      classifier.save_state
    end

  end

end
