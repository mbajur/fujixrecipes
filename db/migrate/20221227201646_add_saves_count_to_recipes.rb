class AddSavesCountToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :saves_count, :integer, default: 0

    Recipe.find_each do |recipe|
      Recipe.reset_counters(recipe.id, :saves)
    end
  end
end
