class MoveFileFormUsersToPhotos < ActiveRecord::Migration
  def change
    remove_column :users, :file
    add_column    :photos, :file, :string
  end
end
