class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string        :title,     null: false
      t.text          :content,   default: ''
      t.integer       :user_id,   null: false
      t.timestamps
    end

    add_index         :stories,   :user_id
  end
end
