class RenameDescriptionToTitle < ActiveRecord::Migration[5.1]
  def change
    rename_column :posts, :description, :title
  end
end
