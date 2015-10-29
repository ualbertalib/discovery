class AddLiasonToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :liason, :string
  end
end
