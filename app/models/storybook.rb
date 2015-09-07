# == Schema Information
#
# Table name: storybooks
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  description  :text
#  cover        :string(255)
#  published    :boolean          default(FALSE)
#  published_on :datetime
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Storybook < ActiveRecord::Base

  # configuration:
  mount_uploader      :cover,       ImageUploader
  include             PublicActivity::Common
  include             PgSearch
  multisearchable     against:      [:title, :description]

  # validations:
  validates           :title,       presence: true
  validates           :cover,       format: { with: /\w+.(gif|jpg|png)\z/i, allow_blank: true }

  # data relationships:
  belongs_to          :user
  has_many            :chapters,    dependent: :destroy
  has_many            :stories,     through: :chapters
  has_many            :activities,  as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy

  # callbacks:
  after_create        :create_activity

  protected

    # create activity method:
    def create_activity
      PublicActivity::Activity.create   key: 'storybook.create', trackable_id: self.id, trackable_type: 'Storybook',
                                        recipient_id: self.user.id, recipient_type: 'User', owner_id: self.user.id, owner_type: 'User',
                                        created_at: self.created_at, parameters: {}
    end

end

