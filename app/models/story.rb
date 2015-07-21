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

  # configuration:
  include             PgSearch
  multisearchable     against:      [:title, :content]
  include             Eventable

  # validations:
  validates           :title,       presence: true

  # data relationships:
  belongs_to          :user
  has_many            :chapters,    dependent: :destroy
  has_many            :storybooks,  through: :chapters
  has_many            :activities,  as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy

  # callbacks:
  after_create        :create_activity

end

