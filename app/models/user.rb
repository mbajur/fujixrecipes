class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
        #  :registerable,
        #  :recoverable,
         :rememberable,
         :validatable,
         :omniauthable

  has_one_attached :avatar

  has_many :recipes
  has_many :saves, class_name: 'Save'
  has_many :saved_recipes, through: :saves, source: :recipe

  validates :avatar, content_type: /\Aimage\/.*\z/

  def to_param
    username
  end
end
