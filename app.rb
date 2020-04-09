require 'sinatra'
require 'httparty'
require 'json'

post '/thanks' do
    status 200
    post_tq params[:text]
    params[:user_name]+', and thank you for spreading some happiness!'
end

post '/happy' do
    status 200
    post_happy params[:text]
    params[:user_name]+',you are spreading the love!'
end

post '/happy-gif' do
  status 200
  post_happy_gif params[:text]
  params[:user_name]+',you like to giphy!'
end

def post_tq message

  slack_webhook = ENV['SLACK_WEBHOOK_URL']

  quiet=HTTParty.post slack_webhook, body:
  {"text" => 'Thanks '+ message,
   "username" => "HappinessBot"}.to_json,
    headers: {'content-type'=>'application/json'}

end


def post_happy message

  slack_webhook = ENV['SLACK_WEBHOOK_URL']

  HTTParty.post slack_webhook, body:
  {"text" => message,
   "username" => "HappinessBot"}.to_json,
    headers: {'content-type'=>'application/json'}

end

def post_happy_gif message

  slack_webhook = ENV['SLACK_WEBHOOK_URL']
  giphy_api_key = 8x96A5YlCJRCqplr4gjULJW13sLtY6FV
  gif_url = "http://api.giphy.com/v1/gifs/search?q="+ message+ "&api_key=" + giphy_api_key + "&limit=5"

  response = HTTParty.get(gif_url), headers: {"Accept" => "application/json" })

  HTTParty.post slack_webhook, response.body

end