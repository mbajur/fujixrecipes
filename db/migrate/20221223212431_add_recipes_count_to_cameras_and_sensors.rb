class AddRecipesCountToCamerasAndSensors < ActiveRecord::Migration[7.0]
  def change
    add_column :cameras, :recipes_count, :integer, default: 0
    add_column :sensors, :recipes_count, :integer, default: 0
  end
end
