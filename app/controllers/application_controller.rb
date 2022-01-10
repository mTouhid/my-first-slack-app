class ApplicationController < ActionController::Base

  protect_from_forgery with: :null_session

  def verify_slack_signature
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
    end
  end
  
end
