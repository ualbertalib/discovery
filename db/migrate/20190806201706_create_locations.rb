class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :short_code
      t.string :name
      t.string :url
      t.references :library, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :locations, :short_code, unique: true

    # Location
    seed_file = Rails.root.join('db', 'migrate/201907', 'location.yml')
    config = YAML.load_file(seed_file)
    config.each do |v|
      library = Library.where(short_code: v.last['library'])
      library = if library.empty?
                  nil
                else
                  library.first
                end
      Location.find_or_create_by(
        short_code: v.first,
        name: v.last['name'],
        url: v.last['locationurl'],
        library: library
      )
    end
  end
end
