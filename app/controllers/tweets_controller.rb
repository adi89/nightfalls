class TweetsController < ApplicationController
  def index
    if request.xhr?
      if params["type"] == 'stream'
        @tweets = Tweet.nightlife.tweet_scan(5).order('created_at desc')
        binding.pry
        if @tweets.present?
          render :tweet, layout: false
        else
          render nothing: true
        end
      elsif params['page']
        @tweets = Tweet.nightlife.recent_tweets(2).order('created_at desc').page(params[:page])
        render layout: false
      end
    else
      @tweets = Tweet.nightlife.recent_tweets(2).order('created_at desc').page(params[:page])
    end
  end

  def categories
    if request.xhr?
      if params['category_id']
        @category = Category.find(params['category_id'])
        @tweets = Tweet.tweet_scan(5).order('created_at desc').where(category_id: params['category_id'])
          if @tweets.present?
            render :tweet, layout: false
          else
            render nothing: true
          end
        elsif params['page']
          @category = Category.find_by(list: params['type'])
          @tweets = Tweet.category_sort(@category.id).page(params[:page]).per(8).order('created_at desc')
          render :index, layout: false
        end
    else
      @category = Category.find_by(list: params['type'])
       @tweets = Tweet.category_sort(@category.id).page(params[:page]).per(8).order('created_at desc')
       render :index
    end
  end
end


#get list info from twitter. looop over collection. find or initialize by id. save over with category id in the relation. save category at the end.

#right now, we get a block of tweets. these blocks of tweets come from the tweet scan method, which look at tweets created in the past minute.