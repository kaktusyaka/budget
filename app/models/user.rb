class User < ActiveRecord::Base
  validates :first_name, :last_name, presence: true, length: { maximum: 255 }

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
end
