class AddRedditUidToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :reddit_uid, :string
    add_index :users, :reddit_uid, unique: true
  end
end
