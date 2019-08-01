# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

[Status, ItemType, CirculationRule, Library, Location].each do |klass|
  seed_file = Rails.root.join('db', 'seeds', "#{klass.name.underscore}.yml")
  config = YAML::load_file(seed_file)
  config.each {|values| klass.first_or_create( { short_code: values.first, name: values.last }) }
end
