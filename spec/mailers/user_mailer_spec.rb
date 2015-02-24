require "spec_helper"

describe UserMailer do

  describe "registration_confirmation" do
    user = User.new(user_attributes(email:'test@example.com'))

    let(:mail) { UserMailer.registration_confirmation(user) }

    it "renders the headers" do
      mail.subject.should eq("FamilyBook registration")
      mail.to.should eq([user.email])
      mail.from.should eq(["no-reply@familybook.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match(user.name)
    end
  end

  describe 'password_reset' do
    user = User.new(user_attributes(email:'test@example.com'))
    user.reset_token = User.new_token

    let(:mail) { UserMailer.password_reset(user) }

    it 'renders the headers' do
      mail.subject.should eq('Password reset')
      mail.to.should eq([user.email])
      mail.from.should eq(["no-reply@familybook.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match(CGI::escape(user.email))
      mail.body.encoded.should match(user.reset_token)
    end
  end

end
