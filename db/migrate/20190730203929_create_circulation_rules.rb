class CreateCirculationRules < ActiveRecord::Migration
  def change
    create_table :circulation_rules do |t|
      t.string :short_code
      t.string :name

      t.timestamps null: false
    end
  end
end
