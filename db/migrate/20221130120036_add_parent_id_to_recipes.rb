class AddParentIdToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_reference :recipes, :parent, foreign_key: { to_table: :recipes }
  end
end
