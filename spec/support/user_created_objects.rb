def create_user_storybooks
  @storybook_1 = @user.storybooks.create!(storybook_attributes)
  @storybook_2 = @user.storybooks.create!(storybook_attributes(title: 'Story Two Title'))
end

def create_user_stories
  @story_1 = @user.stories.create!(story_attributes)
  @story_2 = @user.stories.create!(story_attributes(title: 'Story Two Title'))
end