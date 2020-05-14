# rubocop:disable Style/HashSyntax
desc 'Populate the hathitrust table from a csv'
task :populate_hathitrust_table => :environment do
  require 'csv'
  CSV.open(Rails.root.join('lib', 'tasks', 'files', '20200508_hathitrust_overlap_report.csv'), 'r',
           col_sep: "\t", headers: true).each do |row|
    Hathitrust.create!(row.to_h)
  end
end

desc 'Clear the hathitrust table'
task :clear_hathitrust_table => :environment do
  Hathitrust.delete_all
end
# rubocop:enable Style/HashSyntax
