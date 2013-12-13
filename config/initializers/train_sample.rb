CLASSIFIER = StuffClassifier::Bayes.new("night or discard")
CLASSIFIER.ignore_words = [ 'the', 'my', 'i', 'dont' ]
irrelevant = Tweet.collect_strings(Tweet.irrelevant)
nightlife = Tweet.collect_strings(Tweet.nightlife)

# NIGHT = CLASSIFIER.cls("night")
# DISCARD = CLASSIFIER.cls("discard")

nightlife.each do |tweet|
  CLASSIFIER.train(:night, tweet)
end

irrelevant.each do |tweet|
  CLASSIFIER.train(:discard, tweet)
end

