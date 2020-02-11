class BackupLocation < ActiveRecord::Base
  belongs_to :backup_library
end
