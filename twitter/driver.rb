require_relative 'pages/login_page'
require_relative 'pages/search_page'
require_relative 'pages/tweet_page'

class Twitter
  include Capybara::DSL
  
  MINIMUM_FOLLOWERS = 2000

  attr_accessor :DB

  def initialize(db)
    self.DB = db
  end

  def login
    login_page = TwitterPages::LoginPage.new
    login_page.load
    login_page.login_button.click
    login_page.login_form.username.send_keys ENV.fetch('TWITTER_USERNAME')
    login_page.login_form.password.send_keys ENV.fetch('TWITTER_PASSWORD')
    login_page.login_form.submit.click
  end

  def search
    search_page.load
  end

  def followers(stream_item)
    begin
      search_page.new_tweet_btn.hover
      search_page.wait_until_follower_count_invisible
      stream_item.user_profile_link.hover
      search_page.wait_for_follower_count

      count = search_page.follower_count['title'].gsub(/[^\d\.-]/,'').to_i
      
      script = <<-JS
        arguments[0].scrollIntoView(true);
        window.scrollBy(0,-50)
      JS
      page.driver.browser.execute_script(script, stream_item.root_element.native)

      count
    rescue
      0
    end
  end

  def id(stream_item)
    stream_item.root_element['data-item-id'].to_i
  end

  def read_and_store_results(latest)
    stream_items = search_page.stream_items
    top_id = id(stream_items.first)
    
    search_results = DB[:search_results]

    stream_items.each do |stream_item|
      id = id(stream_item)
      followers = followers(stream_item)
      allowed = (id > latest) && (followers >= MINIMUM_FOLLOWERS)
      if allowed
        record = { tweet_id: id, followers: followers, user_name: stream_item.username.text } 
        search_results.insert(record)
      end
    end
  end

  def post_reply
    search_results = DB[:search_results]
    tweet = search_results.where(reply_sent: false).order(Sequel.desc(:followers))
                          .limit(1)
                          .first

    return if tweet.nil?

    tweet_page.load(user_name: tweet[:user_name], tweet_id: tweet[:tweet_id])
    
    username = "@#{tweet[:user_name]}"
    tweet_page.reply_button.click

    tweet_page.editor.set ".#{username}, I think you mean \"you're welcome\". You're welcome."
    tweet_page.editor.click
    tweet_page.submit_button.click

    search_results.where(id: tweet[:id]).update(reply_sent: true)
  end

  def report_error
  end

  private 

  def search_page
    @search_page ||= TwitterPages::SearchPage.new
  end

  def tweet_page
    @tweet_page  ||= TwitterPages::TweetPage.new
  end
end
