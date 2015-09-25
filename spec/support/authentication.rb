def session_for_user
  session[:user_id] = user.id
end

def session_for_wrong_user
  session[:user_id] = wrong_user.id
end

def sign_out
  session[:user_id] = nil
end

def sign_in(user)
  visit signin_url
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end