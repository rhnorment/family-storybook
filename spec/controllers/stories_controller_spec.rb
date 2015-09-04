require 'rails_helper'

describe StoriesController, type: :controller do

  before do
    create_user
    create_user_stories
  end

  describe 'GET :index' do
    context 'user not signed in' do

    end

    context 'signed in as current user' do

    end
  end

  describe 'GET :new' do
    context 'user not signed in' do

    end

    context 'signed in as current user' do

    end
  end

  context 'POST :create' do
    context 'user not signed in' do

    end

    context 'signed in as current user' do
      context 'when successfully creating a story' do

      end

      context 'when unsuccessfully creating a story' do

      end
    end
  end

  context 'GET :edit' do
    context 'user not signed in' do

    end

    context 'signed in as current user' do

    end
  end

  context 'PATCH :update' do
    context 'user not signed in' do

    end

    context 'signed in as current user' do
      context 'when successfully updating a story' do

      end

      context 'when unsuccessfully updating a story' do

      end

    end
  end

  context 'DELETE :destroy' do
    context 'user not signed in' do

    end

    context 'signed in as current user' do

    end
  end

end