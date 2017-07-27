class AddOwnerToVideos < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :owner, index: true
  end
end
