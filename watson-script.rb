# require 'json'
# require 'cgi'
# require 'firebase'
require 'octokit'
require 'pry'
require "addressable/uri"

client = Octokit::Client.new \
  :login    => 'USERNAME',
  :password => 'PASSWORD'


repo = "zsherman/watson"

existing_labels = client.labels(repo)
existing_names = []

existing_labels.each do |label|
  existing_names << label[:name]
end

module Octokit
  class Client
    def update_label(repo, label, options = {})
      patch "#{Repository.path repo}/labels/#{label}", options
    end
  end
end

labels = [
  { :name => "type: bug", color: "E01B1B" },
  { :name => "type: feature", color: "14AF44" },
  { :name => "priority: low", color: "FFF2D5" },
  { :name => "priority: normal", color: "FFE199" },
  { :name => "priority: high", color: "ECA700" },
  { :name => "needs: design", color: "6D3CEA" },
  { :name => "needs: review", color: "6D3CEA" },
  { :name => "status: preplanning", color: "2780E2" },
  { :name => "status: sprint", color: "2780E2" },
  { :name => "status: in progress", color: "2780E2" },
  { :name => "status: pull request", color: "2780E2" },
  { :name => "status: done", color: "2780E2" },
  { :name => "size: 0.5", color: "EFEFEF" },
  { :name => "size: 1", color: "EFEFEF" },
  { :name => "size: 2", color: "EFEFEF" },
  { :name => "size: 3", color: "EFEFEF" },
  { :name => "size: 5", color: "EFEFEF" },
  { :name => "size: 8", color: "EFEFEF" },
  { :name => "size: 13", color: "EFEFEF" },
  { :name => "size: 20", color: "EFEFEF" },
  { :name => "team: frontend", color: "2C3E50" },
  { :name => "team: backend", color: "2C3E50" },
  { :name => "team: iphone", color: "2C3E50" },
]

# Addressable::URI.encode(Addressable::URI.encode(a))
labels.each do |label|
  if existing_names.include?(label[:name])
    client.update_label(repo, label[:name], {:color => label[:color]})
  else
    client.add_label(repo, label[:name], label[:color])
  end
end

# puts client.label("awaxman11/gh-tester", "type: feature").inspect