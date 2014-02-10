namespace :training_set do
  desc "TODO"
  task import_nightlife: :environment do
    Tweet.fetch_all_tweets('NYNightlife').each do |tweet|
      save_tweets(tweet)
    end
  end
  desc "TODO2"
  task import_nightlife_abridged: :environment do
    Tweet.client.user_timeline_data('NYNightlife', {count: 200}).each do |tweet|
      save_tweets(tweet)
    end
  end

end
