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

post '/happygif' do
  status 200
  post_happy_gif params[:text]
  params[:user_name]+',you like to giphy!'
end

post '/happygif-test' do
  status 200
  post_happy_gif_test params[:response_url], params[:text]
  params[:user_name]+', hang on...just getting some gif options..'
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
  giphy_api_key = '8x96A5YlCJRCqplr4gjULJW13sLtY6FV'
  gif_url = "https://api.giphy.com/v1/gifs/random?api_key=" + giphy_api_key + "&tag="+ message+ "&rating=G"
  response = HTTParty.get(gif_url)

# Image block
image_title = {"type" => "plain_text",
                "text" => response["data"]["title"] + " Powered by Giphy"}

image_block = {"type"=>"image",
  "image_url"=>response["data"]["images"]["downsized"]["url"],
  "alt_text"=>message,
  "title"=>image_title}

# Text block
text_info = {"type"=>"plain_text", "text"=>message}
text_block = {"type"=>"section", "text"=>text_info}

# Combine blocks
blocks=[]
blocks << text_block
blocks << image_block

params_hash={}
params_hash[:blocks]=blocks

HTTParty.post slack_webhook,
              body:params_hash.to_json,
              headers: {'content-type' => 'application/json'}

end

def post_happy_gif_test response_url, message
  slack_webhook = response_url
  giphy_api_key = ENV['GIPHY_API_KEY']
  gif_url = "https://api.giphy.com/v1/gifs/random?api_key=" + giphy_api_key + "&tag="+ message+ "&rating=G"
  response = HTTParty.get(gif_url)

  # Text block
  text_info = {"type"=>"plain_text", "text"=>"Are you happy with this gif?"}
  text_block = {"type"=>"section", "text"=>text_info}

  # Attachment block
  button_text_yes = {
    "type" => "plain_text",
    "text" => "yes"
  }

  button_yes = {
    "type" => "button",
    "text" => button_text_yes,
    "action_id" => "gif_yes_button",
    "value" => "gif_yes"
  }

  button_text_no = {
    "type" => "plain_text",
    "text" => "no"
  }

  button_no = {
    "type" => "button",
    "text" => button_text_no,
    "action_id" => "gif_no_button",
    "value" => "gif_no"
  }


  action_elements=[]
  action_elements << button_yes
  action_elements << button_no

  actions_block = {
    "type" => "actions",
    "elements" => action_elements
  }
  # actions_block[:type]="actions"
  # actions_block[:elements]=action_elements

  # Image block
  image_title = {"type" => "plain_text",
                "text" => response["data"]["title"] + " Powered by Giphy"}

  image_block = {"type"=>"image",
  "image_url"=>response["data"]["images"]["downsized"]["url"],
  "alt_text"=>message,
  "title"=>image_title}

  # Combine blocks
  blocks=[]
  blocks << text_block
  blocks << image_block
  blocks << actions_block

  params_hash={}
  params_hash[:blocks]=blocks

  HTTParty.post slack_webhook,
              body:params_hash.to_json,
              headers: {'content-type' => 'application/json'}

end
