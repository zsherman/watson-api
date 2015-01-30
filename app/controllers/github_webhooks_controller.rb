# app/controllers/github_webhooks_controller.rb
# Rails.application.secrets.key_name
class GithubWebhooksController < ActionController::Base
  # include GithubWebhook::Processor

  def create
    puts "hello"
    render json: params
  end

end