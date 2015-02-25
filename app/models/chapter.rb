# == Schema Information
#
# Table name: chapters
#
#  id           :integer          not null, primary key
#  storybook_id :integer
#  story_id     :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Chapter < ActiveRecord::Base

  # database associations:
  belongs_to :storybook
  belongs_to :story

end
