class Sensor < ApplicationRecord
  def to_param
    slug
  end
end
