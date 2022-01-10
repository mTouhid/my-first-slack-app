Rails.application.routes.draw do
  post 'slack/events', to: 'slack#events'
  post 'slack/touhid', to: 'slack#touhid'
  root "home#index"
end
