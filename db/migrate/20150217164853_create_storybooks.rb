class CreateStorybooks < ActiveRecord::Migration
  def change
    create_table :storybooks do |t|
      t.string :title
      t.text :description
      t.string :cover
      t.boolean :published,   default: false
      t.datetime :published_on
      t.integer :user_id
      t.timestamps
    end
  end
end
