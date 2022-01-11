require 'http'
require 'json'

class SlackController < ApplicationController

  before_action :verify_slack_signature

  def events
    if params[:slack][:type] == "url_verification"
      render plain: params.require(:slack).permit(:challenge)[:challenge]
    elsif params[:slack][:type] == "event_callback" && params[:slack][:event][:type] == "app_mention"
      user = params[:slack][:event][:user]
      HTTP.auth("Bearer #{ENV['MY_OAUTH_TOKEN']}").post("https://slack.com/api/chat.postMessage", :json => {"channel":"C02TX2LNSQG","text":"Hi <@#{user}>"})
    elsif params[:slack][:type] == "event_callback" && params[:slack][:event][:type] == "member_joined_channel"
      user = params[:slack][:event][:user]
      HTTP.auth("Bearer #{ENV['MY_OAUTH_TOKEN']}").post("https://slack.com/api/chat.postMessage", :json => {"channel":"C02TX2LNSQG","text":"Hi <@#{user}>, welcome to this channel."})
    end
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