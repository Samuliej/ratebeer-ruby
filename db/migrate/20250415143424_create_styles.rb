class CreateStyles < ActiveRecord::Migration[8.0]
  def change
    create_table :styles do |t|
      t.string :style
      t.text :description

      t.timestamps
    end
  end
end
