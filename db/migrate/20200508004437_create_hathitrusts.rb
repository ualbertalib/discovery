class CreateHathitrusts < ActiveRecord::Migration
  def change
    create_table :hathitrusts do |t|
      t.integer :oclc, null: false
      t.integer :local_id, null: false, primary_key: true, index: true

      t.timestamps null: false
    end
  end
end
