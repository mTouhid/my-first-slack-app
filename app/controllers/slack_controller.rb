class SlackController < ApplicationController
  def events
    @test = params.require(:slack).permit(:challenge)
  end
end