shared_context 'user not signed in' do
  it { is_expected.to respond_with(:redirect) }
  it { is_expected.to redirect_to(new_session_url) }
  it { is_expected.to set_flash[:alert] }
end

shared_context 'signed in as the current user' do
  it { is_expected.to respond_with(:redirect) }
  it { is_expected.to redirect_to(user) }
  it { is_expected.to_not set_flash }
end

shared_context 'signed in as a different user' do
  it { is_expected.to respond_with(:redirect) }
  it { is_expected.to redirect_to(wrong_user) }
  it { is_expected.to_not set_flash }
end
