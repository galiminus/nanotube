class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :author
      t.references :post
      t.timestamps
    end
  end
end
