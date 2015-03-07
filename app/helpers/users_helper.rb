module UsersHelper

  def profile_image_for(user, options={})
    size = options[:size] || 80
    url = "https://secure.gravatar.com/avatar/#{user.gravatar_id}?s=#{size}"
    image_tag url, alt: user.name
  end

  def storybooks_for(user)
    user.storybooks.pluck(:title).join(', ')
  end

  def stories_for(user)
    user.stories.pluck(:title).join(', ')
  end

end
