# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[Status, ItemType, CirculationRule].each do |klass|
  seed_file = Rails.root.join('db', 'seeds', "#{klass.name.underscore}.yml")
  config = YAML.load_file(seed_file)
  config.each { |k, v| klass.where(short_code: k, name: v).first_or_create }
end

# Library
seed_file = Rails.root.join('db', 'seeds', 'library.yml')
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

# Location
seed_file = Rails.root.join('db', 'seeds', 'location.yml')
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
