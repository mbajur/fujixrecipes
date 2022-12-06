class AddColorTemperatureToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :color_temperature, :integer
  end
end
