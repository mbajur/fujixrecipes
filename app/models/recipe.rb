class Recipe < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  belongs_to :parent, class_name: 'Recipe', optional: true
  belongs_to :sensor, class_name: 'Sensor', optional: true, foreign_key: :sensor_id
  has_many :saves, class_name: 'Save', dependent: :destroy

  has_one_attached :poster
  has_one_attached :photo_1
  has_one_attached :photo_2

  enum film_simulation: {
    provia: 0,
    velvia: 1,
    astia: 2,
    classic_chrome: 3,
    pro_neg_hi: 4,
    pro_neg_std: 5,
    classic_neg: 6,
    eterna: 7,
    eterna_bleach_bypass: 8,
    acros: 9,
    monochrome: 10,
    sepia: 11
  }, _prefix: true

  enum dynamic_range: {
    auto: 0,
    '100%': 1,
    '200%': 2,
    '400%': 3
  }, _prefix: true

  enum grain_roughness: {
    off: 0,
    weak: 1,
    strong: 2
  }, _prefix: true

  enum grain_size: {
    small: 0,
    large: 1
  }, _prefix: true

  enum white_balance: {
    auto: 0,
    white_priority: 1,
    ambience_priority: 2,
    color_temperature: 3,
    daylight: 4,
    shade: 5,
    fluorescent_light_1: 6,
    fluorescent_light_2: 7,
    fluorescent_light_3: 8,
    incandescent: 9,
    underwater: 10
  }, _prefix: true

  enum color_chrome_effect: {
    off: 0,
    weak: 1,
    strong: 2
  }, _prefix: true

  enum color_chrome_effect_blue: {
    off: 0,
    weak: 1,
    strong: 2
  }, _prefix: true

  enum :source_type, {
    local: 0,
    external: 1
  }, prefix: true

  validates :name, presence: true
  validates :sensor, presence: true
  validates :poster, attached: true, content_type: :jpg

  validates :color_temperature, presence: true, numericality: true, if: :white_balance_color_temperature?

  with_options if: :source_type_local? do |recipe|
    recipe.validates :film_simulation, presence: true
    recipe.validates :photo_1, content_type: :jpg
    recipe.validates :photo_2, content_type: :jpg
  end

  with_options if: :source_type_external? do |recipe|
    recipe.validates :original_author, presence: true
    recipe.validates :original_url, presence: true, uniqueness: { scope: :source_type }
  end

  def saved_by?(user)
    saves.find_by(user: user).present?
  end
end
