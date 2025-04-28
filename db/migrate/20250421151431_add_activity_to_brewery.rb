class AddActivityToBrewery < ActiveRecord::Migration[8.0]
  def change
    add_column :breweries, :active, :boolean
  end
end
