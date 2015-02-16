class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :reset_token
      t.datetime :reset_sent_at
      t.timestamps
    end
    add_index :users, :email
  end
end
