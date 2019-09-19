class CreateItemTypes < ActiveRecord::Migration
  def change
    create_table :item_types do |t|
      t.string :short_code
      t.string :name

      t.timestamps null: false
    end

    # ItemType
    seed_file = Rails.root.join('db', 'migrate/201907', "#{ItemType.name.underscore}.yml")
    config = YAML.load_file(seed_file)
    config.each { |k, v| ItemType.where(short_code: k, name: v).first_or_create }
  end
end
