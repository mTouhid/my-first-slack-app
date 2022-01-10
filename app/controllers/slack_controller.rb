class SlackController < ApplicationController

  before_action :verify_slack_signature

  def events
    render plain: params.require(:slack).permit(:challenge)[:challenge]
  end
  
end