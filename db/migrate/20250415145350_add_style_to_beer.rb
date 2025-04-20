class AddStyleToBeer < ActiveRecord::Migration[8.0]
  def change
    add_reference :beers, :style, null: false, foreign_key: true
  end
end
