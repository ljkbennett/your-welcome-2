require 'capybara/dsl'
require 'site_prism'
require 'sequel'

require './twitter/driver'

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium
  config.app_host = 'https://www.twitter.com'
end

DB = Sequel.connect(ENV.fetch('DATABASE_URL'))

twitter = Twitter.new(DB)
twitter.login

while true do
  begin
    twitter.search
    twitter.read_and_store_results(DB[:search_results].max(:tweet_id) || 0)
    twitter.post_reply
    sleep 45
  rescue Exception => e
    puts e
    sleep 60
  end
end
