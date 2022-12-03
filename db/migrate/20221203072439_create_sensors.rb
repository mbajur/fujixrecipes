class CreateSensors < ActiveRecord::Migration[7.0]
  def change
    create_table :sensors do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :sensors, :name, unique: true
    add_index :sensors, :slug, unique: true
  end
end
