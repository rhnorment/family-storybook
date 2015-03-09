module StorybooksHelper

  def image_for(storybook)
    storybook.cover.blank? ? 'default_cover_s5czvu.jpg' : storybook.cover_url
  end

  def render_published_status(storybook)
    storybook.published? ? 'Published' : 'Not published'
  end

end
