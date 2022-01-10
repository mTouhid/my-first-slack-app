require 'http'
require 'json'

class SlackController < ApplicationController

  before_action :verify_slack_signature

  def events
    render plain: params.require(:slack).permit(:challenge)[:challenge]
    send_message
  end

  private

  def send_message
    HTTP.post(ENV['MY_SLACK_WEBHOOK_URL'], :json => {"type":"mrkdwn","text":"*Test Test Test*\n_2_"})
  end

end