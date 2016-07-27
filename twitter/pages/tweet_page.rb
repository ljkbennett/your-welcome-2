module TwitterPages
  class TweetPage < SitePrism::Page
    set_url 'https://twitter.com{/user_name}/status{/tweet_id}'

    element :reply_button, '.permalink-tweet .ProfileTweet-actionButton.js-actionReply'

    element :editor, '.tweet-box.rich-editor'
    element :submit_button, '.PermalinkOverlay-modal .tweet-btn'

    elements :tweet_replies, '.permalink-container .replies-to .stream'
  end
end
