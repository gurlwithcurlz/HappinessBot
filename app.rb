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
    params[:user_name]+', "you''re spreading the love!"
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
