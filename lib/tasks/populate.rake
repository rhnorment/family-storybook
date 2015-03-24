namespace   :db do

  require 'faker'
  require 'populator'

  desc    'Erase and fill database'

  task    populate: :environment do

    # make_users
    # make_storybooks
    # make_stories
    # add_activity_to_users
    # create_storybook_activities
    # create_story_activities
    # destroy_all_data
  end

  # private methods

  def make_users
    # User.delete_all
    # User.create!(name: 'Hunt Norment', email: 'norment@gmail.com', password: 'mmedia',
    #              password_confirmation: 'mmedia', member: true, admin: true)
    User.populate(50) do |user|
      user.name                   = Faker::Name.name
      user.email                  = Faker::Internet.email
      user.password_digest        = 'password'
    end
  end

  def make_storybooks
    # Storybook.delete_all
    # Storybook.create!(title: 'Storybook for Hunt', description: 'This book is for Hunt', published: false, user_id: 1)
    Storybook.populate(50) do |storybook|
      storybook.title         = Faker::Commerce.product_name
      storybook.description   = Faker::Lorem.sentence
      storybook.published     = false
      storybook.user_id       = 1..10
      storybook.cover         = 'Blank.png'
    end
  end


  def make_stories
    # Story.delete_all
    # Story.create!(title: 'Riding a Bike', content: 'This is a story about Hunt learning to ride a bike', user_id: 1)
    Story.populate(50) do |story|
      story.title             = Faker::Lorem.sentence
      story.content           = Faker::Lorem.paragraphs
      story.user_id           = 1..10
    end
  end

  def add_activity_to_users
    users = User.all
    users.each do |user|
      PublicActivity::Activity.create   key: 'user.create', trackable_id: user.id, trackable_type: 'User',
                                        recipient_id: user.id, recipient_type: 'User', owner_id: user.id,
                                        owner_type: 'User', created_at: user.created_at, parameters: {}
    end
  end

  def create_storybook_activities
    storybooks = Storybook.all
    storybooks.each do |storybook|
      PublicActivity::Activity.create   key: 'storybook.create', trackable_id: storybook.id, trackable_type: 'Storybook',
                                        recipient_id: storybook.user_id, recipient_type: 'User', owner_id: storybook.user_id,
                                        owner_type: 'User', created_at: storybook.created_at, parameters: {}
    end
  end

  def create_story_activities
    stories = Story.all
    stories.each do |story|
      PublicActivity::Activity.create   key: 'story.create', trackable_id: story.id, trackable_type: 'Story',
                                        recipient_id: story.user_id, recipient_type: 'User', owner_id: story.user_id,
                                        owner_type: 'User', created_at: story.created_at, parameters: {}
    end
  end

  def destroy_all_data
    User.delete_all
    Storybook.delete_all
    Story.delete_all
    PublicActivity::Activity.delete_all
  end

end