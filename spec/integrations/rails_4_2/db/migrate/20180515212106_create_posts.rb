class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.boolean :published
      t.decimal :amount
      t.integer :tracking_id
      t.string :email
      t.string :password_digest

      t.timestamps null: false
    end
    add_index :posts, :tracking_id, unique: true
    add_index :posts, :email, unique: true
  end
end
