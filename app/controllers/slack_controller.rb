require 'http'
require 'json'

class SlackController < ApplicationController

  before_action :verify_slack_signature

  def events
    render plain: params.require(:slack).permit(:challenge)[:challenge]
    user = params[:slack][:event][:user]
    HTTP.auth("Bearer #{ENV['MY_OAUTH_TOKEN']}").post("https://slack.com/api/chat.postMessage", :json => {"channel":"C02TX2LNSQG","text":"Hi <@#{user}>"})
  end

  def touhid
    render plain: "Command received!"
    HTTP.auth("Bearer #{ENV['MY_OAUTH_TOKEN']}").post("https://slack.com/api/chat.postMessage", :json => {"channel":"C02TX2LNSQG","text":"Hi @Touhidul Islam"})
  end

  private

  def send_message
    HTTP.post(ENV['MY_SLACK_WEBHOOK_URL'], :json => {"type":"mrkdwn","text":"*Test Test Test*\n_2_"})
  end

end