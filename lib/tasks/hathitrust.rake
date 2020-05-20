namespace :hathitrust do
  desc 'Populate the hathitrust table from a csv'
  task populate_table: :environment do
    require 'csv'
    CSV.foreach(Rails.root.join('lib', 'tasks', 'files', '20200508_hathitrust_overlap_report.csv'),
                col_sep: "\t", headers: true).with_index do |row, index|

      print '.' if ((index + 1) % 100).zero?
      print "(#{index + 1})\n" if ((index + 1) % 5000).zero?

      ActiveRecord::Base.connection.execute("INSERT IGNORE INTO hathitrust_overlap_records (catalog_id, oclc) VALUES
                                             (#{row['catalog_id']}, #{row['oclc']});")
    end
    print "\nFinished!\n"
  end

  desc 'Clear the hathitrust table'
  task clear_table: :environment do
    HathitrustOverlapRecord.delete_all
    print "\nFinished!\n"
  end
end
