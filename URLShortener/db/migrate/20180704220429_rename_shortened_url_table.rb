class RenameShortenedUrlTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :shortened_url, :shortened_urls
  end
end
