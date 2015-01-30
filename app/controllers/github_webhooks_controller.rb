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
    json_issue = parsed['issue'].to_json
    issue = JSON.parse(json_issue)
    add_repo_and_org(issue)
    add_category(issue)
    response = firebase.update(parsed["issue"]["id"], issue)
    head :ok, content_type: "text/html"
  end

  def add_repo_and_org(issue)
    url = issue["url"]
    url_array = url.split("/")
    org = url_array[4]
    repo = url_array[5]

    issue["organization"] = org
    issue["repo"] = repo
  end

  def add_category(issue)
    title = issue["title"]
    bracket_index = title.index("]")
    if bracket_index
      category = title.slice(0..bracket_index.to_i)
      clean_category = category.delete('[]')
      issue["category"] = clean_category.downcase
    else 
      issue["category"] = ""
    end
  end
end
