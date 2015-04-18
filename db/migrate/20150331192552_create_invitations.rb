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

  end
end
