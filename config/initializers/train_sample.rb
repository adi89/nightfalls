require 'redis'
    @key = "stuff-classifier"
    @redis_options = {host: ENV['REDIS_URL'], port: ENV['REDIS_PORT']}
    @storage = StuffClassifier::RedisStorage.new(@key, @redis_options)
    StuffClassifier::Base.storage = @storage

    #disk
    # @store = StuffClassifier::FileStorage.new('/tmp/stuff.db')
    # StuffClassifier::Base.storage = @store

