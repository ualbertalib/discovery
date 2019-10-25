class ChangeToUtf8Encoding < ActiveRecord::Migration
  def change

    db = ActiveRecord::Base.connection

    execute "ALTER DATABASE `#{db.current_database}` CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    db.tables.each do |table|
      execute "ALTER TABLE `#{table}` CHARACTER SET utf8 COLLATE utf8_unicode_ci;"

      execute "ALTER TABLE `#{table}` CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
    end

  end
end
