class AddListToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :list, :string
  end
end
