class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_one_attached :avatar

  has_many :recipes
  has_many :saves, class_name: 'Save'
  has_many :saved_recipes, through: :saves, source: :recipe

  validates :avatar, content_type: /\Aimage\/.*\z/
  validates :username, presence: true, uniqueness: true
  validates :username, format: { with: /\A[a-z0-9_]+\z/i }, length: { maximum: 30 }
  validates :display_name, length: { maximum: 30 }
  validates :bio, length: { maximum: 500 }

  def to_param
    username
  end
end
