class AddSourceToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :source_type, :integer, default: 0
  end
end
