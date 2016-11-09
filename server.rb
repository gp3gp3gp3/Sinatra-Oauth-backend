require 'sinatra'
require 'twitter'
require 'pry'

config = {
  consumer_key: ENV["TWITTER_CONSUMER_KEY"],
  consumer_secret: ENV["TWITTER_CONSUMER_SECRET"]
}


get '/' do
  client = Twitter::REST::Client.new(config)
  puts "*" * 30
  puts client.user('gp3gp3gp3')
  binding.pry
  puts "*" * 30
end