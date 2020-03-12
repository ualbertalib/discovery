class CreateBackupTables < ActiveRecord::Migration
  def change
    create_table :backup_libraries do |t|
      t.string :short_code
      t.string :name
      t.string :url
      t.string :neos_url
      t.string :proxy

      t.timestamps null: false
    end
    create_table :backup_locations do |t|
      t.string :short_code
      t.string :name
      t.string :url
      t.references :backup_library, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
