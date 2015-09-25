def create_user
  User.create!(user_attributes)
end

def create_inactive_user
  User.create!(user_attributes(active: false))
end

def create_other_users
  @user_2 = User.create!(user_attributes(name: 'User Two', email: 'user_2@example.com'))
  @user_3 = User.create!(user_attributes(name: 'User Three', email: 'user_3@example.com'))
  @user_4 = User.create!(user_attributes(name: 'User Four', email: 'user_4@example.com'))
  @user_5 = User.create!(user_attributes(name: 'User Five', email: 'user_5@example.com'))
end

def create_user_storybooks
  @storybook_1 = @user.storybooks.create!(storybook_attributes)
  @storybook_2 = @user.storybooks.create!(storybook_attributes(title: 'Storybook Two Title'))
end

def create_user_stories
  @story_1 = @user.stories.create!(story_attributes)
  @story_2 = @user.stories.create!(story_attributes(title: 'Story Two Title'))
end

def create_storybook_stories
  @storybook_1.stories << [@story_1, @story_2]
end

def create_user_relationships
  Relationship.create!(user_id: @user.id, relative_id: @user_2.id, pending: false)
  Relationship.create!(user_id: @user.id, relative_id: @user_3.id, pending: false)
end

def create_user_invitations
  @user.invitations.create!(recipient_email: 'invitee@example.com')
end
