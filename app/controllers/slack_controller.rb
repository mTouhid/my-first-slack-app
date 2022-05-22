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
        selected_user = TeamMember.order(Arel.sql('RANDOM()')).first[:user]
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
    render plain: modal
    HTTP.auth("Bearer #{ENV['MY_OAUTH_TOKEN']}").post("https://slack.com/api/views.open", :json => {"channel":"C02TX2LNSQG","trigger_id":params[:trigger_id],"view":modal})
    HTTP.auth("Bearer #{ENV['MY_OAUTH_TOKEN']}").post("https://slack.com/api/chat.postMessage", :json => {"channel":"C02TX2LNSQG","text":"Hi @Touhidul Islam"})
  end

  private

  def send_message
    HTTP.post(ENV['MY_SLACK_WEBHOOK_URL'], :json => {"type":"mrkdwn","text":"*Test Test Test*\n_2_"})
  end

  def modal
    [
      {
        "type": "modal",
        "submit": {
          "type": "plain_text",
          "text": "Submit",
          "emoji": true
        },
        "close": {
          "type": "plain_text",
          "text": "Cancel",
          "emoji": true
        },
        "title": {
          "type": "plain_text",
          "text": "Randomly select a host",
          "emoji": true
        },
        "blocks": [
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "*Hi <fakelink.toUser.com|@David>!* Please provide some more details:"
            }
          },
          {
            "type": "divider"
          },
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": ":clipboard: *Type of ceremony*\nChoose a ceremony from this list"
            },
            "accessory": {
              "type": "static_select",
              "placeholder": {
                "type": "plain_text",
                "text": "Choose list",
                "emoji": true
              },
              "options": [
                {
                  "text": {
                    "type": "plain_text",
                    "text": "Stand up",
                    "emoji": true
                  },
                  "value": "value-0"
                },
                {
                  "text": {
                    "type": "plain_text",
                    "text": "Sprint retrospective",
                    "emoji": true
                  },
                  "value": "value-1"
                }
              ]
            }
          }
        ]
      }
    ].to_json
  end

end