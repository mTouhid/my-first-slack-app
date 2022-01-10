class SlackController < ApplicationController
  def events
    byebug
    @challenge = params.require(:slack).permit(:challenge)
    @timestamp = request.headers['X-Slack-Request-Timestamp']
    puts @challenge
    puts @timestamp
  end
end