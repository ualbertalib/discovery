class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :short_code
      t.string :name

      t.timestamps null: false
    end
  end
end
