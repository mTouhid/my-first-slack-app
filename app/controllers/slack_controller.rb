require 'json'

class SlackController < ApplicationController
  def events
    slack_signing_secret = ENV["MY_SLACK_SIGNING_SECRET"]
    @challenge = params.require(:slack).permit(:challenge)
    timestamp = request.headers['X-Slack-Request-Timestamp']
    request_body = URI.encode_www_form(request.params)
    sig_basestring = "v0:#{@timestamp}:#{request_body}"
    digest = OpenSSL::Digest.new('sha256')
    hmac_hexdigest = OpenSSL::HMAC.hexdigest(digest, slack_signing_secret, request_body)
    my_signature = "v0=#{hmac_hexdigest}"
    slack_signature = request.headers['X-Slack-Signature']
    puts @challenge
    puts timestamp
    puts slack_signing_secret
    puts request_body
    puts my_signature
    puts slack_signature
    if my_signature == slack_signature
      puts "Yesssss!"
    else
      puts "Nooooooo!"
    end
  end
end