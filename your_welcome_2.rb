require 'capybara/dsl'
require 'capybara/poltergeist'
require 'site_prism'

require './twitter/driver'

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium
  config.app_host = 'https://www.twitter.com'
end

twitter = Twitter.new
twitter.login

last_reply = ''

while true do
  begin
    twitter.search
    last_reply = twitter.post_reply(last_reply)
    sleep 45
  rescue Exception => e
    puts e
    sleep 60
  end
end
