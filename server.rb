require 'sinatra'
require 'twitter'
require 'pry'
require 'json'

TWITTER_USERNAMES = [
  'VancityReynolds',
  'DAVID_LYNCH',
  'ConanOBrien',
  'prattprattpratt',
  'BillGates',
  'StephenAtHome',
  'elonmusk',
  'rickygervais',
  'BarackObama',
  'kanyewest'
]

def twitter_client
  config = {
    consumer_key: ENV["TWITTER_CONSUMER_KEY"],
    consumer_secret: ENV["TWITTER_CONSUMER_SECRET"]
  }
  Twitter::REST::Client.new(config)
end

def get_twitter_user(user_name)
  user_hash = {}
  client = twitter_client
  twitter_obj = client.user(user_name)
  user_hash['user_name'] = twitter_obj.screen_name
  user_hash['full_name'] = twitter_obj.name
  user_hash['followers_count'] = twitter_obj.followers_count
  user_hash['friends_count'] = twitter_obj.friends_count
  user_hash
end

get '/' do
  stream_hash = {}
  twitter_users = TWITTER_USERNAMES.map do |user_name|
    get_twitter_user(user_name)
  end
  stream_hash['twitter'] = twitter_users
  content_type :json
  stream_hash.to_json
end