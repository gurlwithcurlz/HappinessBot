require 'sinatra'
require 'httparty'
require 'json'

post '/thanks' do
    status 200
    post_tq params[:text]
end

post '/happy' do
    status 200
    post_happy params[:text]
end

def post_tq message

  slack_webhook = ENV['SLACK_WEBHOOK_URL']

  HTTParty.post slack_webhook, body:
  {"text" => 'thanks '+ message,
   "username" => "HappinessBot"}.to_json,
    headers: {'content-type'=>'application/json'}

end


def post_happy message

  slack_webhook = ENV['SLACK_WEBHOOK_URL']

  HTTParty.post slack_webhook, body:
  {"text" => message.to_s,
   "username" => "HappinessBot"}.to_json,
    headers: {'content-type'=>'application/json'}

end
