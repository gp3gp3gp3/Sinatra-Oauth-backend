require 'sinatra'
require 'twitter'
require 'pry'
require 'json'
require 'koala'
require 'sinatra/cross_origin'
require 'net/http'
require 'uri'

configure do
  enable :cross_origin
end

CELEBRITIES = [
  {
    twitter: 'VancityReynolds',
    facebook: 'VancityReynolds'
  },
  {
    twitter: 'DAVID_LYNCH',
    facebook: 'davidlynchofficial'
  },
  {
    twitter: 'ConanOBrien',
    facebook: 'teamcoco'
  },
  {
    twitter: 'prattprattpratt',
    facebook: 'PrattPrattPratt'
  },
  {
    twitter: 'BillGates',
    facebook: 'BillGates'
  },
  {
    twitter: 'StephenAtHome',
    facebook: 105550416146299
  },
  {
    twitter: 'elonmusk',
    facebook: 108250442531979
  },
  {
    twitter: 'rickygervais',
    facebook: 'rickygervais'
  },
  {
    twitter: 'BarackObama',
    facebook: 'barackobama'
  },
  {
    twitter: 'kanyewest',
    facebook: 107777555911981
  }
]

def facebook_graph
  Koala::Facebook::API.new(ENV['FACEBOOK_ACCESS_TOKEN'])
end

def get_facebook_user_likes(user_name)
  facebook_hash = facebook_graph.api("#{user_name}?fields=fan_count")
  facebook_hash['fan_count']
end

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
  user_hash['profile_image_url'] = twitter_obj.profile_image_url_https(:original).to_s
  user_hash
end

get '/' do
  content_type :json
  response = CELEBRITIES.map do |celebrity|
    res_hash = get_twitter_user(celebrity[:twitter])
    res_hash['fb_likes'] = get_facebook_user_likes(celebrity[:facebook])
    res_hash
  end
  response.to_json
end

get '/instagram' do
  uri = URI.parse("https://api.instagram.com/oauth/access_token")
  response = Net::HTTP.post_form(uri, {
    "client_id" => "f98db0ad5d2648f095525ea0986f4d1a",
    "client_secret" => ENV["INSTAGRAM_CLIENT_SECRET"],
    "grant_type" => "authorization_code",
    "redirect_uri" => "https://gp3gp3gp3.github.io/instagram-clone/", # set to var depending on local enviornment
    "code" => params["code"]
  })
  response.body
end