require 'json'

class SlackController < ApplicationController
  def events
    # slack_signing_secret = ENV["MY_SLACK_SIGNING_SECRET"]
    # @challenge = params.require(:slack).permit(:challenge)
    # timestamp = request.headers['X-Slack-Request-Timestamp']
    # request_body = URI.encode_www_form(request.params[:slack])
    # sig_basestring = "v0:#{timestamp}:#{request_body}"
    # digest = OpenSSL::Digest.new('sha256')
    # hmac_hexdigest = OpenSSL::HMAC.hexdigest(digest, slack_signing_secret, request_body)
    # my_signature = "v0=#{hmac_hexdigest}"
    # slack_signature = request.headers['X-Slack-Signature']
    # puts @challenge
    # puts timestamp
    # puts slack_signing_secret
    # puts request_body
    # puts sig_basestring
    # puts my_signature
    # puts slack_signature
    # if my_signature == slack_signature
    #   puts "Yesssss!"
    # else
    #   puts "Nooooooo!"
    # end
    signing_secret = ENV['MY_SLACK_SIGNING_SECRET']
    version_number = 'v0' # always v0 for now
    timestamp = request.headers['X-Slack-Request-Timestamp']
    raw_body = request.body.read # raw body JSON string

    if Time.at(timestamp.to_i) < 5.minutes.ago
      # could be a replay attack
      render nothing: true, status: :bad_request
      return
    end

    sig_basestring = [version_number, timestamp, raw_body].join(':')
    digest = OpenSSL::Digest::SHA256.new
    hex_hash = OpenSSL::HMAC.hexdigest(digest, signing_secret, sig_basestring)
    computed_signature = [version_number, hex_hash].join('=')
    slack_signature = request.headers['X-Slack-Signature']

    if computed_signature != slack_signature
      render nothing: true, status: :unauthorized
    else
      puts "Yessssssss!"
    end
  end
end