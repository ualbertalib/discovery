# seeds.rb
require 'csv'

CSV.foreach("db/csv/staff.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
  Profile.create(row.to_hash)
end
