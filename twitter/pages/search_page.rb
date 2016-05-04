module TwitterPages
  class SearchPage < SitePrism::Page
    set_url 'https://twitter.com/search?f=tweets&vertical=default&q=%22Your%20welcome%22&src=typd'

    sections :stream_items, 'ol.stream-items li.stream-item' do
      element :username, '.account-group .username b'
      element :reply_button, '.ProfileTweet-actionButton.js-actionReply'
    end

    element :editor, '.tweet-box.rich-editor'
    element :submit_button, '.modal-tweet-form-container .tweet-btn'
  end
end
