class AddDetailsToRepresentatives < ActiveRecord::Migration[5.2]
  def change
    add_column :representatives, :address, :jsonb
    add_column :representatives, :party, :string
    add_column :representatives, :photo_url, :string
  end
end
