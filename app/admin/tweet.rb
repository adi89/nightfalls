ActiveAdmin.register Tweet do
  permit_params :username, :text, :id, :tweet_code

  index do
    column :id
    column :username
    column :text
    column 'state' do |tweet|
      link_to(tweet.state, '#', class: "tweet-admin-state", data: {id: tweet.id})
    end
    column :tweet_code
    default_actions
  end


  collection_action :state, :method => :get do
    tweet = Tweet.find(params['id'])
    case params['state']
    when 'irrelevant'
      tweet.night
    when 'nightlife'
      tweet.discard
    end
    render :json => {:state => "#{tweet.state}"}, :status => :ok
  end

end
