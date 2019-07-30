class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.integer :short_code
      t.references :library, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
