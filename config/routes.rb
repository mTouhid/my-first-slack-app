Rails.application.routes.draw do
  post 'slack/events', to: 'slack#events'
  root "home#index"
end
