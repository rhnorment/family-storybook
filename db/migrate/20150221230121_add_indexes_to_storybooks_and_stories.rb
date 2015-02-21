class AddIndexesToStorybooksAndStories < ActiveRecord::Migration
  def change
    add_index   :storybooks,  :user_id
    add_index   :stories,     :user_id
  end
end
