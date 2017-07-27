class AddErrorToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :error, :boolean, default: false
  end
end
