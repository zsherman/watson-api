# app/controllers/github_webhooks_controller.rb
# Rails.application.secrets.key_name
class GithubWebhooksController < ActionController::Base
  # include GithubWebhook::Processor

  def create
    base_uri = 'https://flickering-inferno-8924.firebaseio.com/'
    firebase = Firebase::Client.new(base_uri)
    response = firebase.push("issues-test", params)
    puts "hello"
    render json: params
  end

end