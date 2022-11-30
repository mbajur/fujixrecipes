class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.integer :film_simulation, default: 0, null: false
      t.integer :dynamic_range, default: 0, null: false
      t.integer :highlights, default: 0, null: false
      t.integer :shadows, default: 0, null: false
      t.integer :color, default: 0, null: false
      t.integer :noise_reduction, default: 0, null: false
      t.integer :sharpening, default: 0, null: false
      t.integer :clarity, default: 0, null: false
      t.integer :grain_roughness, default: 0, null: false
      t.integer :grain_size, default: 0, null: false
      t.integer :color_chrome_effect, default: 0, null: false
      t.integer :color_chrome_effect_blue, default: 0, null: false
      t.integer :white_balance, default: 0, null: false
      t.integer :white_balance_red, default: 0, null: false
      t.integer :white_balance_blue, default: 0, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
