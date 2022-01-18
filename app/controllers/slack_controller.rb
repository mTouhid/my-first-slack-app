require 'http'
require 'json'

class SlackController < ApplicationController

  before_action :verify_slack_signature

  def events
    if params[:slack][:type] == "url_verification"
      render plain: params.require(:slack).permit(:challenge)[:challenge]
    elsif params[:slack][:type] == "event_callback" && params[:slack][:event][:type] == "app_mention"
      user = params[:slack][:event][:user]
      channel = params[:slack][:event][:channel]
      if params[:slack][:event][:text].include? "register"
        team_member = TeamMember.new(user: params.require(:slack).require(:event).permit(:user))
        if team_member.save
          HTTP.auth("Bearer #{ENV['MY_OAUTH_TOKEN']}").post("https://slack.com/api/chat.postMessage", :json => {"channel":channel,"text":"Hi <@#{user}>, you are registered."})
        else
          HTTP.auth("Bearer #{ENV['MY_OAUTH_TOKEN']}").post("https://slack.com/api/chat.postMessage", :json => {"channel":channel,"text":"Hi <@#{user}>, Something went wrong."})
        end
      elsif params[:slack][:event][:text].include? "select"
        selected_user = TeamMember.order(Arel.sql('RANDOM()')).first.user
        HTTP.auth("Bearer #{ENV['MY_OAUTH_TOKEN']}").post("https://slack.com/api/chat.postMessage", :json => {"channel":channel,"text":"Hi <@#{selected_user}>, you have been selected."})
      else
        HTTP.auth("Bearer #{ENV['MY_OAUTH_TOKEN']}").post("https://slack.com/api/chat.postMessage", :json => {"channel":channel,"text":"Hi <@#{user}>, I am not sure."})
      end
    elsif params[:slack][:type] == "event_callback" && params[:slack][:event][:type] == "member_joined_channel"
      user = params[:slack][:event][:user]
      channel = params[:slack][:event][:channel]
      HTTP.auth("Bearer #{ENV['MY_OAUTH_TOKEN']}").post("https://slack.com/api/chat.postMessage", :json => {"channel":channel,"text":"Hi <@#{user}>, welcome to <@#{channel}>."})
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