module LoginHelper
  def login_to_system
    @user = Fabricate(:user)
    User.stub(:from_omniauth).and_return(@user)
    click_link('Sign in with Twitter')
    if page.has_css? '#username_or_email'
      fill_in 'username_or_email', with: @user.email
      fill_in 'password', with: @user.password
    end
    find('#allow').click
  end
end
