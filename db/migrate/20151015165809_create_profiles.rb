class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :job_title
      t.string :unit
      t.string :email
      t.string :phone
      t.string :campus_address
      t.string :expertise
      t.text :introduction
      t.text :publications
      t.integer :staff_since
      t.string :links
      t.string :orcid
      t.string :committees
      t.text :personal_interests
      t.boolean :opt_in

      t.timestamps null: false
    end
  end
end
