module TwitterPages
  class LoginPage < SitePrism::Page
    set_url '/'

    element :login_button, '.Button.StreamsLogin'

    section :login_form, '.LoginForm' do
      element :username, '.LoginForm-username input'
      element :password, '.LoginForm-password input'
      element :submit, '.btn.submit'
    end
  end
end
