class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.string :short_code
      t.string :name
      t.string :url
      t.string :neos_url
      t.string :proxy

      t.timestamps null: false
    end
  end
end
