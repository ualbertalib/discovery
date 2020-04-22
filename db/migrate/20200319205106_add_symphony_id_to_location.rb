class AddSymphonyIdToLocation < ActiveRecord::Migration
  CODES = {
    'AGINTERNET' => 1,
    'AGL_CAP' => 2,
    'NORQ_MAIN' => 3,
    'AHS_RVGH' => 4,
    'NORQ_WEST' => 5,
    'CONCORD_IN' => 6,
    'AHS_KEC' => 7,
    'KEYANO' => 8,
    'NLC_GR' => 9,
    'AHS_TBCC' => 10,
    'NLC_INT' => 11,
    'AITF_C-FER' => 12,
    'NEOS_FREE' => 13,
    'AITF_MW' => 14,
    'AITF_VEG' => 15,
    'UAAUG' => 16,
    'COVENANTGN' => 17,
    'COVENANTMH' => 18,
    'AHSGLENRSE' => 20,
    'CONCORDIA' => 21,
    'NLC_SL' => 22,
    'BURMAN' => 23,
    'GR_MAC_TSV' => 24,
    'AHS_INT' => 27,
    'GPRC_GP' => 28,
    'GR_MACEWAN' => 29,
    'KINGS' => 31,
    'NEWMAN' => 32,
    'OLDS' => 33,
    'CONCORDSEM' => 34,
    'RED_DEER_C' => 35,
    'TAYLOR' => 36,
    'UAARCHIVES' => 37,
    'UARCRF' => 38,
    'UABSJ' => 39,
    'UABUSINESS' => 40,
    'UAEDUC' => 41,
    'UAHLTHSC' => 42,
    'UAHSS' => 43,
    'UAINTERNET' => 44,
    'UALAW' => 45,
    'UAMATH' => 46,
    'AHS_REDDR' => 47,
    'UASCITECH' => 48,
    'UASJC' => 49,
    'UASPCOLL' => 50,
    'UATECHSERV' => 51,
    'LAKELND_LL' => 52,
    'LAKELND_VR' => 53,
    'GPRC_FRVW' => 54,
    'GR_MAC_ACC' => 55,
    'GR_MAC_INT' => 57,
    'AHS_ACH' => 58,
    'VANGUARD' => 59,
    'GPRC_INT' => 60,
    'LAKELND_IN' => 61
  }.freeze

  def up
    # the Symphony id is used by SolrMarc to map from 596a to Institution
    add_column :locations, :symphony_id, :integer, default: nil

    Location.reset_column_information

    CODES.each do |short_code, symphony_id|
      entry = Location.find_or_initialize_by(short_code: short_code)
      entry.symphony_id = symphony_id
      entry.save
    end
    
  end

  def down
    remove_column :locations, :symphony_id
  end
end
