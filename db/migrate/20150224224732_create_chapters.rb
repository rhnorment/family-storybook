class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.references :storybook, null: false, index: true
      t.references :story,     null: false, index: true
      t.timestamps
    end
  end
end
