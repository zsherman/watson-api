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
    create_property_from_label(issue)
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
      issue["category"] = nil
    end
  end

  def parse_label_type(issue, label)
    label_types = ['needs', 'priority', 'size', 'status', 'team' ,'type']
    issue["name"] = nil
    label_type = label["name"].split(":").first
    label_value = label["name"].split(":").last.strip
    if label_types.include?(label_type)
      issue[label_type] = label_value
    end
  end

  def create_property_from_label(issue)
    labels = issue["labels"]
    labels.each do |label|
      parse_label_type(issue, label)
    end
  end
end
