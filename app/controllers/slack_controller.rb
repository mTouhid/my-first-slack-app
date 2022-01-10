class SlackController < ApplicationController
  def events
    @test = params.require(:slack).permit(:body)
  end
end