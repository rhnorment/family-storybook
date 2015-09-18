class CreateRelationships < ActiveRecord::Migration
  def up
    create_table :relationships do |t|
      t.integer :user_id,       null: false
      t.integer :relative_id,   null: false
      t.boolean :pending,       default: true
      t.timestamps
    end
    add_index   :relationships, [:user_id, :relative_id], unique: true
  end
  def down
    drop_table :relationships
  end
end
