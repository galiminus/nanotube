class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :name
      t.string :content_type
      t.string :path
      t.string :md5
      t.integer :size
      t.timestamps
    end
  end
end
