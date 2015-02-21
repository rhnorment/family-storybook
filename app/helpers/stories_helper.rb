module StoriesHelper

  def action_for(story)
    story.new_record? ? 'Save' : 'Update'
  end


end
