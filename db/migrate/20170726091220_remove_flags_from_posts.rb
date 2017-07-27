class RemoveFlagsFromPosts < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :transcoded
    remove_column :posts, :error
  end
end
