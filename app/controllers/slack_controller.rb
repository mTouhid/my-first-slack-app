require 'http'
require 'json'

class SlackController < ApplicationController

  before_action :verify_slack_signature

  def events
    render plain: params.require(:slack).permit(:challenge)[:challenge]
    send_message(params.require(:slack).permit(:challenge)[:challenge])
  end

  private

  def send_message(message)
    HTTP.post("https://hooks.slack.com/services/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", :json => {"type":"mrkdwn","text":"*Test Test Test*\n_2_"})
  end

end