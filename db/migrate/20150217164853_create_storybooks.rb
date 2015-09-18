class CreateStorybooks < ActiveRecord::Migration
  def change
    create_table :storybooks do |t|
      t.string :title,          null: false
      t.text :description,      default: ''
      t.string :cover
      t.boolean :published,     default: false
      t.date :published_on
      t.integer :user_id,       null: false
      t.timestamps
    end

    add_index   :storybooks,    :user_id
  end
end
