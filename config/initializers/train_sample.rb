require 'redis'
    @key = "stuff-classifier"
    # @redis_options = { host: 'http://redistogo:9e2a2e377715c850a14297f8a107736e@crestfish.redistogo.com', port: 10559 }

    # @storage = StuffClassifier::RedisStorage.new(@key, @redis_options)
    # StuffClassifier::Base.storage = @storage

    # @redis_options = { host: 'localhost', port: 6379 }
    # redis = Redis.new(@redis_options)

    #disk
    # @store = StuffClassifier::FileStorage.new('/tmp/stuff.db')
    # StuffClassifier::Base.storage = @store

