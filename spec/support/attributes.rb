def user_attributes(overrides = {})
  {
    name: 'Example User',
    email: 'user@example.com',
    password: 'secret',
    password_confirmation: 'secret'
  }.merge(overrides)
end

def storybook_attributes(overrides = {})
  {
      title: 'Storybook Title',
      description: 'This is a storybook description',
      cover: 'cover.jpg'
  }.merge(overrides)
end

def story_attributes(overrides = {})
  {
      title: 'Story Title',
      content: 'This is a story description',
  }.merge(overrides)
end
