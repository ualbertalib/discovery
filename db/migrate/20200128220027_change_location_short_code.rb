class ChangeLocationShortCode < ActiveRecord::Migration
  CODES = {
    'aginternet' => 'AGINTERNET',
    'aglcap' => 'AGL_CAP',
    'ahsach' => 'AHS_ACH',
    'ahskec' => 'AHS_KEC',
    'ahsreddr' => 'AHS_REDDR',
    'ahsrvgh' => 'AHS_RVGH',
    'ahstbcc' => 'AHS_TBCC',
    'ahsint' => 'AHS_INT',
    'ahsglenrse' => 'AHSGLENRSE',
    'aitfcfer' => 'AITF_C-FER',
    'aitfmw' => 'AITF_MW',
    'aitfveg' => 'AITF_VEG',
    'burman' => 'BURMAN',
    'concordia' => 'CONCORDIA',
    'concordsem' => 'CONCORDSEM',
    'covenantgn' => 'COVENANTGN',
    'covenantmh' => 'COVENANTMH',
    'gprcgp' => 'GPRC_GP',
    'gprcfrvw' => 'GPRC_FRVW',
    'gprcint' => 'GPRC_INT',
    'grmacacc' => 'GR_MAC_ACC',
    'grmacint' => 'GR_MAC_INT',
    'grmactsv' => 'GR_MAC_TSV',
    'grmacewan' => 'GR_MACEWAN',
    'keyano' => 'KEYANO',
    'kings' => 'KINGS',
    'lakelndin' => 'LAKELND_IN',
    'lakelndll' => 'LAKELND_LL',
    'lakelndvr' => 'LAKELND_VR',
    'neosfree' => 'NEOS_FREE',
    'newman' => 'NEWMAN',
    'nlcgr' => 'NLC_GR',
    'nlcint' => 'NLC_INT',
    'nlcsl' => 'NLC_SL',
    'norqmain' => 'NORQ_MAIN',
    'norqwest' => 'NORQ_WEST',
    'olds' => 'OLDS',
    'reddeerc' => 'RED_DEER_C',
    'taylor' => 'TAYLOR',
    'vanguard' => 'VANGUARD',
    'uaarchives' => 'UAARCHIVES',
    'uaaug' => 'UAAUG',
    'uabsj' => 'UABSJ',
    'uabusiness' => 'UABUSINESS',
    'uaeduc' => 'UAEDUC',
    'uahlthsc' => 'UAHLTHSC',
    'uahss' => 'UAHSS',
    'uainternet' => 'UAINTERNET',
    'ualaw' => 'UALAW',
    'uamath' => 'UAMATH',
    'uascitech' => 'UASCITECH',
    'uasjc' => 'UASJC',
    'uaspcoll' => 'UASPCOLL',
    'uatechserv' => 'UATECHSERV',
    'uarcrf' => 'UARCRF'
  }

  def up
    CODES.each do |old_code,new_code|
      entry = Location.find_or_initialize_by(short_code: old_code)
      entry.short_code = new_code
      entry.save
    end
  end

  def down
    CODES.invert.each do |old_code,new_code|
      entry = Location.find_or_initialize_by(short_code: old_code)
      entry.short_code = new_code
      entry.save
    end
  end
end
