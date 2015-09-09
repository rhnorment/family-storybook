class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :trackable, polymorphic: true
      t.references :owner, polymorphic: true
      t.references :recipient, polymorphic: true
      t.string :key
      t.text :parameters

      t.timestamps null: false
    end

    add_index   :activities,  [:trackable_id, :trackable_type]
    add_index   :activities,  [:owner_id, :owner_type]
    add_index   :activities,  [:recipient_id, :recipient_type]
  end
end
