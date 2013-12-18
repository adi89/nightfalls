ActiveAdmin.register Category do
  permit_params :name, :id, tweets_attributes: [:id, :username, :text, :tweet_code]

  index do
    column :id
    column :name
    default_actions
  end

end