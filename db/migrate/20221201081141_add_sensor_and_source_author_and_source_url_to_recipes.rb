class AddSensorAndSourceAuthorAndSourceUrlToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :sensor, :integer
    add_column :recipes, :original_author, :string
    add_column :recipes, :original_url, :string
  end
end
