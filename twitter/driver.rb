require_relative 'pages/login_page'
require_relative 'pages/search_page'

class Twitter
  include Capybara::DSL

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
    stream_item.user_profile_link.hover
    search_page.wait_for_follower_count
    search_page.follower_count.text
  end

  def post_reply(last)
    stream_items = search_page.stream_items.reject do |stream_item|
      id <= stream_item.root_element['data-item-id']
    end

    stream_item = stream_items.max do |a,b|
      followers(a) <=> followers(b) 
    end
    
    if stream_item
      username = "@#{stream_item.username.text}"
      stream_item.reply_button.click

      search_page.editor.set ".#{username}, I think you mean \"you're welcome\". You're welcome."
      search_page.editor.click
      search_page.submit_button.click
    end
    id
  end

  def report_error
  end

  private 

  def search_page
    @search_page ||= TwitterPages::SearchPage.new
  end
end
