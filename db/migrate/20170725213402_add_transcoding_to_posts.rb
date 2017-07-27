class AddTranscodingToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :state, :string, index: true
  end
end
