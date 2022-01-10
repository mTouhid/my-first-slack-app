class SlackController < ApplicationController
  def events
    slack_signing_secret = ENV["MY_SLACK_SIGNING_SECRET"]
    @challenge = params.require(:slack).permit(:challenge)
    timestamp = request.headers['X-Slack-Request-Timestamp']
    request_body = request.body()
    sig_basestring = 'v0:' + @timestamp + ':' + request_body
    my_signature = 'v0=' + hmac.compute_hash_sha256(
      slack_signing_secret,
      sig_basestring
      ).hexdigest()
    puts @challenge
    puts timestamp
    puts slack_signing_secret
    puts request_body
    puts my_signature
  end
end