class CreateHathitrustOverlapRecords < ActiveRecord::Migration
  def change
    create_table :hathitrust_overlap_records, id: false do |t|
      t.integer :catalog_id, null: false
      t.integer :oclc, null: false
    end

    add_index :hathitrust_overlap_records, :catalog_id, unique: true
  end
end
