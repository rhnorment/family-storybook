class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.string  :recipient_email
      t.string :token
      t.datetime :sent_at
      t.datetime :accepted_at
      t.timestamps
    end
    add_index   :invitations, :user_id
    add_index   :invitations, :recipient_email
    add_index   :invitations, :token
    add_index   :invitations, [:user_id, :recipient_email], unique: true
  end
end
