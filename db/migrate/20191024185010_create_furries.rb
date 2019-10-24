class CreateFurries < ActiveRecord::Migration[6.0]
  def change
    create_table :furries do |t|
      t.string :name
      t.string :specie

      t.timestamps
    end
  end
end
