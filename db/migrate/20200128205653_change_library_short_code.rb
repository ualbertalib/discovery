class ChangeLibraryShortCode < ActiveRecord::Migration
  CODES = {
    'abhealth' => 'AHS_',
    'gov' => 'AGL_',
    'innovates' => 'AITF_',
    'burmanuniversity' => 'BUR_',
    'concordia' => 'CONCORDIA_',
    'covenant' => 'COVENANT_',
    'gp' => 'GPRC_',
    'keyano' => 'KEYANO_',
    'kings' => 'KINGS_',
    'lakeland' => 'LAKELAND_',
    'macewanuniversity' => 'MACEWAN_',
    'newman' => 'NEWMAN_',
    'norquest' => 'NORQUEST_',
    'nlc' => 'NLC_',
    'olds' => 'OLDS_',
    'reddeer' => 'RDC',
    'universityofalberta' => 'UINTERNET_',
    'vanguard' => 'VANGUARD_',
    'free' => '',
    'neos' => 'NEOS_FREE_'
  }

  def up
    add_column :libraries, :old_short_code, :string

    # before using the old_short_code we need to reset the connection
    Library.connection.schema_cache.clear!
    Library.reset_column_information

    CODES.each do |old_code,new_code|
      entry = Library.find_or_initialize_by(short_code: old_code)
      entry.short_code = new_code
      entry.old_short_code = old_code
      entry.save
    end
  end

  def down
    remove_column :libraries, :old_short_code
    CODES.invert.each do |new_code,old_code|
      entry = Library.find_or_initialize_by(short_code: new_code)
      entry.short_code = old_code
      entry.save
    end
  end
end
