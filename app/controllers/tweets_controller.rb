class TweetsController < ApplicationController
  def index
    if request.xhr?
      if params["type"] == 'stream'
        str = params['str']
        @tweets = Tweet.nightlife.tweet_scan(5).unique_tweets(str).order('created_at desc')
        if @tweets.present?
          render :tweet, layout: false
        else
          render nothing: true
        end
      elsif params['page']
        tweet_records = Tweet.nightlife.recent_tweets(2).order('created_at desc')
        @list = tweet_records.pluck(:username).uniq
        @tweets = tweet_records.page(params[:page])
        render layout: false
      end
    else
      tweet_records = Tweet.nightlife.recent_tweets(2).order('created_at desc')
      @tweets = tweet_records.page(params[:page])
      @list = tweet_records.pluck(:username).uniq
    end
  end

  def categories
    if request.xhr?
      if params['category_id']
        @category = Category.find(params['category_id'])
        str = params['str']
        @tweets = Tweet.tweet_scan(5).unique_tweets(str).where(category_id: params['category_id']).order('created_at desc')
          if @tweets.present?
            render :tweet, layout: false
          else
            render nothing: true
          end
        elsif params['page']
          @category = Category.find_by(list: params['type'])
          tweet_records = Tweet.category_sort(@category.id).recent_tweets(2).order('created_at desc').recent_tweets(2).order('created_at desc')
          @tweets = tweet_records.page(params[:page])
          @list = tweet_records.pluck(:username).uniq
          render :index, layout: false
        end
    else
      @category = Category.find_by(list: params['type'])
      tweet_records = Tweet.category_sort(@category.id).recent_tweets(2).order('created_at desc')
      @tweets = tweet_records.page(params[:page])
      @list = tweet_records.pluck(:username).uniq
       render :index
    end
  end
end

#get list info from twitter. looop over collection. find or initialize by id. save over with category id in the relation. save category at the end.

#right now, we get a block of tweets. these blocks of tweets come from the tweet scan method, which look at tweets created in the past minute.