class SlackController < ApplicationController
  def events
    @slack_signing_secret = ENV["MY_SLACK_SIGNING_SECRET"]
    @challenge = params.require(:slack).permit(:challenge)
    @timestamp = request.headers['X-Slack-Request-Timestamp']
    @request_body = request.body()
    puts @challenge
    puts @timestamp
    puts @slack_signing_secret
    puts @request_body
  end
end