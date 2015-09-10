def create_user
  @user = User.create!(user_attributes)
end

def create_other_users
  @user_2 = User.create!(user_attributes(name: 'User Two', email: 'user_2@example.com'))
  @user_3 = User.create!(user_attributes(name: 'User Three', email: 'user_3@example.com'))
  @user_4 = User.create!(user_attributes(name: 'User Four', email: 'user_4@example.com'))
  @user_5 = User.create!(user_attributes(name: 'User Five', email: 'user_5@example.com'))
end

def create_and_sign_in_wrong_user
  @wrong_user = User.create!(user_attributes(name: 'Wrong User', email: 'wrong_user@example.com'))
  session[:user_id] = @wrong_user.id
end

def sign_in_current_user
  session[:user_id] = @user.id
end

def sign_out_current_user
  session[:user_id] = nil
end

def sign_in(user)
  visit signin_url
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end
