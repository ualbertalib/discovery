class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :short_code
      t.string :name
      t.string :url
      t.references :library, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :locations, :short_code, unique: true
  end
end
