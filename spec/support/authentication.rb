def create_user
  @user = User.create!(user_attributes)
end

def create_and_sign_in_current_user
  @user = User.create!(user_attributes)
  session[:user_id] = @user.id
end

def create_and_sign_in_wrong_user
  @wrong_user = User.create!(user_attributes(name: 'Wrong User', email: 'wrong_user@example.com'))
  session[:user_id] = @wrong_user.id
end

def sign_in(user)
  visit signin_url
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end
