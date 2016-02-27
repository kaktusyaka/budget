class Photo < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
  attr_accessor :remote_file_url
  mount_uploader :file, FileUploader
end
