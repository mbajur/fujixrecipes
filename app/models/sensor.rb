class Sensor < ApplicationRecord
  has_many :recipes

  def self.compatibility_matrix
    {
      xtrans1: [:xtrans1],
      xtrans2: [:xtrans1, :xtrans2],
      xtrans3: [:xtrans1, :xtrans2, :xtrans3],
      xtrans4: [:xtrans1, :xtrans2, :xtrans3, :xtrans4],
      xtrans5: [:xtrans1, :xtrans2, :xtrans3, :xtrans4, :xtrans5],
      bayer:   [:bayer],
      gfx:     [:gfx]
    }
  end

  def to_param
    slug
  end
end
