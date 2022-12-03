class AddSensorToRecipes < ActiveRecord::Migration[7.0]
  def change
    rename_column :recipes, :sensor, :sensor_old
    add_reference :recipes, :sensor, null: true, foreign_key: true
  end
end
