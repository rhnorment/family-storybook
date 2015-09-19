# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  content    :text             default("")
#  user_id    :integer          not null
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


