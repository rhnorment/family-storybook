require 'rails_helper'

describe TokenGenerator, type: :module do

  describe '#new_token' do
    it 'should generate a new token' do
      expect(TokenGenerator.new_token).to_not be_nil
    end
  end

end

