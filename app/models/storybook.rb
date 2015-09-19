# == Schema Information
#
# Table name: storybooks
#
#  id           :integer          not null, primary key
#  title        :string           not null
#  description  :text             default("")
#  cover        :string
#  published    :boolean          default(FALSE)
#  published_on :date
#  user_id      :integer          not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Storybook < ActiveRecord::Base

  include             PgSearch
  include             Trackable

  mount_uploader      :cover,       ImageUploader

  multisearchable     against:      [:title, :description]

  belongs_to          :user
  has_many            :chapters,      dependent: :destroy
  has_many            :stories,       through: :chapters

  validates           :cover,       format: { with: /\w+.(gif|jpg|png)\z/i, allow_blank: true }
  validates           :title,       presence: true
  validates           :user_id,     presence: true

  after_create        :track_activity

end

