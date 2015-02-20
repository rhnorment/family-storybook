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

  # validations:
  validates           :title,       presence: true

  # data relationships:
  belongs_to          :user


end
