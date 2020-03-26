class AddSymphonyIdToLocation < ActiveRecord::Migration
  def change
    # the Symphony id is used by SolrMarc to map from 596a to Institution
    add_column :locations, :symphony_id, :integer, default: nil
  end
end
