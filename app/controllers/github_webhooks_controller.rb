# app/controllers/github_webhooks_controller.rb
# Rails.application.secrets.key_name
class GithubWebhooksController < ActionController::API
  include GithubWebhook::Processor

  def push(payload)
    # TODO: handle push webhook
    logger.info "push_payload"
  end

  def webhook_secret(payload)
    logger.info "webhook_secret"
  end

  def issues(payload)
    logger.info payload
  end

  def create(payload)
    logger.info payload
  end

end