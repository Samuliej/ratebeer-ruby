class RenameStyleInStyle < ActiveRecord::Migration[8.0]
  def change
    rename_column :styles, :style, :name
  end
end
