class ChangeToUtf8mbEncoding < ActiveRecord::Migration
  def change

    db = ActiveRecord::Base.connection

    execute "ALTER DATABASE `#{db.current_database}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    db.tables.each do |table|
      execute "ALTER TABLE `#{table}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

      db.columns(table).each do |column|
        case column.sql_type
          when /([a-z]*)text/i
            default = (column.default.nil?) ? '' : "DEFAULT '#{column.default}'"
            null = (column.null) ? '' : 'NOT NULL'
            execute "ALTER TABLE `#{table}` MODIFY `#{column.name}` #{column.sql_type.upcase} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci #{default} #{null};"
          when /varchar\(([0-9]+)\)/i
            sql_type = column.sql_type.upcase
            default = (column.default.nil?) ? '' : "DEFAULT '#{column.default}'"
            null = (column.null) ? '' : 'NOT NULL'
            execute "ALTER TABLE `#{table}` MODIFY `#{column.name}` #{sql_type} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci #{default} #{null};"
        end
      end
    end

  end
end
