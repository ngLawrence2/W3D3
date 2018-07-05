class ShortenedUrls < ActiveRecord::Migration[5.1]
  def change
    create_table :shortened_url do |t|
      t.integer :user_id, null: false
      t.string :long_url, null: false
      t.string :short_url, null: false
      t.timestamps
    end
    add_index :shortened_url, [:long_url, :short_url], unique: true
    add_index :shortened_url, :short_url, unique: true
  end
end
