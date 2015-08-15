shared_context 'a user not signed in' do
  it { should respond_with(:redirect) }
  it { should redirect_to(new_session_url) }
  it { should set_flash[:alert] }
end

shared_context 'signed in as a different user' do
  it { should respond_with(:redirect) }
  it { should redirect_to(@wrong_user) }
  it { should_not set_flash }
end

shared_context 'signed in as the current user' do
  it { should respond_with(:redirect) }
  it { should redirect_to(@user) }
  it { should_not set_flash }
end