# app/controllers/github_webhooks_controller.rb
# Rails.application.secrets.key_name
class GithubWebhooksController < ActionController::Base
  # include GithubWebhook::Processor
  require 'cgi'

  def create
    base_uri = 'https://flickering-inferno-8924.firebaseio.com/issues'
    firebase = Firebase::Client.new(base_uri)
    cgi_parsed = CGI::parse(request.raw_post)
    parsed = JSON.parse(cgi_parsed['payload'][0])
    issue0 = parsed['issue'].to_json
    issue3 = JSON.parse(issue0)
    issue1 = issue0.gsub!(/\"/, '\'')
    issue2 = issue1.slice(1, issue1.length-1)
    response = firebase.update(parsed["issue"]["id"], issue3)
    head :ok, content_type: "text/html"
  end
end