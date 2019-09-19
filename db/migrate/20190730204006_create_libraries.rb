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

    # Library
    seed_file = Rails.root.join('db', 'migrate/201907', 'library.yml')
    config = YAML.load_file(seed_file)
    config.each do |v|
      Library.where(
        short_code: v.first,
        name: v.last['name'],
        url: v.last['url'],
        neos_url: v.last['neosurl'],
        proxy: v.last['proxy']
      ).first_or_create
    end
  end
end
