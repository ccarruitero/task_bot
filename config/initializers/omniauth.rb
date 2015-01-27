Rails.application.config.middleware.use OmniAuth::Builder do
  provider :redbooth, ENV['REDBOOTH_APP_ID'], ENV['REDBOOTH_APP_SECRET']
  provider :trello, ENV['TRELLO_APP_KEY'], ENV['TRELLO_APP_SECRET'],
           app_name: ENV['TRELLO_APP_NAME'], scope: 'read,write,account',
           expiration: 'never'
end
