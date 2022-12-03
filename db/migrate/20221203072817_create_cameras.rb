class CreateCameras < ActiveRecord::Migration[7.0]
  def change
    create_table :cameras do |t|
      t.string :name
      t.string :slug
      t.references :sensor, null: false, foreign_key: true, index: true

      t.timestamps
    end
    add_index :cameras, :name, unique: true
    add_index :cameras, :slug, unique: true
  end
end
