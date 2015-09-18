# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Story < ActiveRecord::Base

  include             PgSearch
  include             Trackable

  multisearchable     against:        [:title, :content]

  belongs_to          :user
  has_many            :chapters,      dependent: :destroy
  has_many            :storybooks,    through: :chapters

  validates           :title,         presence: true
  validates           :user_id,       presence: true

  after_create        :track_activity

end


