class SlackController < ApplicationController
  def events
    @challenge = params.require(:slack).permit(:challenge)
    puts @challenge
  end
end