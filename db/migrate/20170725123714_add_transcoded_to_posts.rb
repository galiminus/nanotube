class AddTranscodedToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :transcoded, :boolean, default: false
  end
end
