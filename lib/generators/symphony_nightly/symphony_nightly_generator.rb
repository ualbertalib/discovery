class SymphonyNightlyGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path('templates', __dir__)
  desc "Creates a new database migration from the current symphony config
  data dump found at `data/data4discovery`"

  HUMAN_READBLE_STRINGS_FROM_SYMPHONY_FILE = 'data/data4discovery.txt'.freeze
  HUMAN_READABLE_STRINGS_FROM_EZPROXY_FILE = 'data/Data4DiscoveryManual.txt'.freeze

  def self.next_migration_number(path)
    next_migration_number = current_migration_number(path) + 1
    ActiveRecord::Migration.next_migration_number(next_migration_number)
  end

  def copy_migrations
    abort "#{HUMAN_READBLE_STRINGS_FROM_SYMPHONY_FILE} is missing." unless File.exist?(HUMAN_READBLE_STRINGS_FROM_SYMPHONY_FILE)
    abort "#{HUMAN_READABLE_STRINGS_FROM_EZPROXY_FILE} is missing." unless File.exist?(HUMAN_READABLE_STRINGS_FROM_EZPROXY_FILE)

    # in order to create a new migration every night we need to make the migration
    # unique.  Here we append today's date.
    migration_template 'update_symphony_nightly.erb',
                       "db/migrate/update_symphony_nightly_#{Time.now.strftime('%Y%m%d')}.rb"
  end
end
