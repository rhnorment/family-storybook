module ActivitiesHelper

  def render_each(activity)
    key = activity.key.split('.')[0]
    render partial: "activities/#{key}", locals: { activity: activity }
  end

end
