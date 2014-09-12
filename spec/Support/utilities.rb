include ApplicationHelper

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.username
    fill_in "Password", with: user.password
    click_button "Sign In"
  end
end

Rspec::Matchers.define :respond_to_user_attributes do
	match do |user|
		expect(user).to respond_to(:name)
		expect(user).to respond_to(:password_digest)
		expect(user).to respond_to(:password)
		expect(user).to respond_to(:password_confirmation)
		expect(user).to respond_to(:authenticate)
		expect(user).to respond_to(:remember_token)
		expect(user).to respond_to(:admin)
    expect(user).to respond_to(:microposts)
    expect(user).to respond_to(:feed)
    expect(user).to respond_to(:relationships)
    expect(user).to respond_to(:followed_users)
    expect(user).to respond_to(:following?)
    expect(user).to respond_to(:follow!)
    expect(user).to respond_to(:unfollow!)
    expect(user).to respond_to(:followers)
    expect(user).to respond_to(:password_reset_sent_at)
    expect(user).to respond_to(:password_reset_token)
    expect(user).to respond_to(:username)
	end
end

