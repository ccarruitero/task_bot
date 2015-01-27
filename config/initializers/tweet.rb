require 'pubnub'

if ENV['PUBNUB_PUBLISH_KEY'] and ENV['PUBNUB_SUBSCRIBE_KEY']

  pubnub = Pubnub.new(
    :publish=> ENV['PUBNUB_PUBLISH_KEY'],
    :subscribe_key => ENV['PUBNUB_SUBSCRIBE_KEY'],
    :error_callback   => lambda { |msg|
      puts "SOMETHING WRONG HAPPENED: #{msg.inspect}"
    },
    :connect_callback => lambda { |msg|
      puts "CONNECTED: #{msg.inspect}"
    }
  )

  sub_callback = lambda { |envelope|
    msg = JSON.parse envelope.msg
    twitter_user = msg['user']['screen_name']
    text = msg['text']
    user = User.find_by twitter_id: twitter_user
    if !user.nil?
      user.create_task text
    end
   }

  pubnub.subscribe(
    channel: ENV['PUBNUB_CHANNEL'],
    callback: sub_callback
  )
end
