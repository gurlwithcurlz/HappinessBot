require 'sinatra'
require 'httparty'
require 'json'

post '/anonymize' do
    status 200
    post_tq params[:text], params[:channel_id]
end

def post_tq message, channel_id

  slack_webhook = ENV['SLACK_WEBHOOK_URL']

  HTTParty.post slack_webhook, body:
  {"text" => message.to_s,
   "username" => "HappinessBot",
   "channel" => params[:channel_id]}.to_json,
    headers: {'content-type'=>'application/json'}

end
