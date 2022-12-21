class Camera < ApplicationRecord
  belongs_to :sensor

  def to_param
    slug
  end
end
