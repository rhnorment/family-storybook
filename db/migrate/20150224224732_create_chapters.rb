class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.references :storybook, index: true
      t.references :story, index: true
      t.timestamps
    end
  end
end
