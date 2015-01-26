class UserObserver < ActiveRecord::Observer
  def after_update user
    scheduler = Rufus::Scheduler.new
    d = DateTime.now + 7200.seconds
    expire_date = "#{d.year}/#{d.month}/#{d.day} #{d.hour}:#{d.minute}:#{d.sec}"
    scheduler.at expire_date do
      user.get_token
    end
  end
end
