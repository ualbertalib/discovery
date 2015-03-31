require_relative "../../spec_helper.rb"

include E

describe DatabaseVocabulary do

  let(:database){ DatabaseVocabulary.from_xml(File.open(E::*("fixtures/database_record.xml"))) }

  it "should be a database OM Vocabulary with a terminology-based solrizer" do
    expect(database).to be_an_instance_of DatabaseVocabulary
    expect(database).to be_a_kind_of OM::XML::Document
    expect(database).to be_a_kind_of OM::XML::TerminologyBasedSolrizer
  end

  it "should hold all the database object fields" do
    expect(database.id).to eq ["106"]
    expect(database.core).to eq [""]
    expect(database.db_display).to eq [""]
    expect(database.language).to eq ["english"]
    expect(database.resource_type).to eq ["Database - Citation"]
    expect(database.conditions_of_use).to eq ["0"]
    expect(database.title).to eq ["Web of Science Core Collection"]
    expect(database.search_title).to eq ["Web of Science Core Collection"]
    expect(database.software).to eq [""]
    expect(database.branding).to eq ["none"]
    expect(database.ua_only).to eq ["1"]
    expect(database.new).to eq [""]
    expect(database.user_contact).to eq ["hss,scitech"]
    expect(database.local_access_info).to eq [""]
    expect(database.abstract).to eq ["The Web of Science provides online access to the following citation  databases:  <UL class=\"arrows indent\"> <LI>Art & Humanities Citation Index<SUP>®</SUP> (1975-present)  <li>Book Citation Index - Science (2005-present) <li>Book Citation Index - Social Sciences & Humanities (2005-present) <li>Conference Proceedings Citation Index - Science (1990-present) <li>Conference Proceedings Citation Index - Social Science & Humanities (1990-present) <LI>Science Citation Index Expanded<SUP><FONT size=-2>(TM)</FONT></SUP>  (1899-present)  <LI>Social Sciences Citation Index<SUP>®</SUP> (1898-present)  </UL>"]
    expect(database.coverage).to eq [""]
    expect(database.url).to eq [""]
    expect(database.conditions).to eq ["Use of this product is restricted to members of the University of Alberta community and to users of the Library's physical facilities. It is the responsibility of each user to ensure that he or she uses this product for individual, non-commercial educational or research purposes only, and does not systematically download or retain substantial portions of information. "]
    expect(database.date_added_old).to eq ["2000-06-27"]
    expect(database.date_updated_old).to eq ["02/17/2005"]
    expect(database.author).to eq [""]
    expect(database.contributor).to eq [""]
    expect(database.unit_library ).to eq ["hss,scitech"]
    expect(database.comments).to eq ["Former title (changed January 16, 2014): Web of Science  Note deleted January 16, 2014: Internet Explorer 9 Users - If you encounter problems, please use <a href=\"http://support.microsoft.com/kb/956197\">Compatibility Mode</a>  Old URL (Changed January 14, 2014): http://isiknowledge.com/wos  <li><i>Book Citation Index - Science (2003-present) - trial access until November 11, 2011</i> <li><i>Book Citation Index - Social Sciences & Humanities (2003-present) - trial access until November 11, 2011</i>  Removed Sept. 7, 2011: <A href=\"http://www.isinet.com/isihome/media/presentrep/tspdf/wos-6-1-0903-QRC.pdf\">Quick Reference  Card</A> <IMG align=absMiddle alt=PDF border=0 height=24  src=\"http://www.library.ualberta.ca/images/pdficon.gif\" width=22> </LI>  If the above link doesn't work, temporary access available <a href=\"http://isi4.isiknowledge.com/\">here</a>.  Old link (changed Sept. 2/02): http://woscanada.isihost.com "]
    expect(database.single_search_id).to eq ["WOS"]
    expect(database.primary_url).to eq ["http://webofknowledge.com/WOS"]
    expect(database.primary_url_type).to eq ["Web"]
    expect(database.supp_info).to eq [""]
    expect(database.order_title).to eq ["web of science core collection"]
    expect(database.cdrom).to eq [""]
    expect(database.concurrent_limits).to eq [""]
    expect(database.short_description).to eq ["Citation databases for Arts & Humanities, Science, and Social Sciences"]
    expect(database.sponsor).to eq [""]
    expect(database.stats_link).to eq [""]
    expect(database.vendor_link).to eq [""]
    expect(database.vendor_id).to eq ["1"]
    expect(database.open_url).to eq ["Y"]
    expect(database.open_url_date).to eq ["2004-07-16 09:35:30"]
    expect(database.date_added).to eq ["2000-06-27 00:00:00"]
    expect(database.date_updated).to eq ["2014-01-16 08:19:46"]
    expect(database.error_message).to eq [""]
    expect(database.loishole_logo).to eq ["0"]
    expect(database.french_title).to eq [""]
    expect(database.french_order_title).to eq [""]
    expect(database.french_short_description).to eq ["Bases de données de citations en arts, sciences humaines et sociales, sciences pures"]
    expect(database.french_supp_info).to eq ["Utilisateurs d'Internet Explorer 9 - Si vous rencontrez des problèmes, utilisez le <a href=\"http://support.microsoft.com/kb/956197\">mode de compatibilité</a>."]
    expect(database.french_user_contact).to eq [""]
    expect(database.french_local_access_info).to eq ["<ul class=\"arrows\"> <li>Tutoriel : <a href=\"http://www.library.ualberta.ca/instruction_fr/tutoriels/index.cfm#websci\">La recherche dans Web of Science</a> <li><strong>Utilisateurs d'Internet Explorer 9 (IE9)</strong> : Si vous rencontrez des problèmes lors de l'affichage des résultats, il vous est conseillé d'utiliser le mode de compatibilité. Cette fonction est accessible sous Tools > Compatibility View ou en cliquant sur l'icône représentant une page déchirée, près de la barre où s'affiche l'URL. Pour plus de renseignements à ce sujet, veuillez consulter l'article suivant tiré du Knowledgebase de Microsoft : <a href=\"http://support.microsoft.com/kb/956197\">http://support.microsoft.com/kb/956197</a> (en anglais). <li><a href=\"http://wokinfo.com/training_support/training/\">Training and Support Materials</a>"]
    expect(database.french_abstract).to eq ["Web of Science fournit l'accès en ligne aux bases de données bibliographiques suivantes : <UL class=\"arrows\"> <LI>Art & Humanities Citation Index®  (à partir de 1975) <LI>Book Citation Index - Science (à partir de 2005) <LI>Book Citation Index - Social Sciences & Humanities (à partir de 2005) <LI>Conference Proceedings Citation Index - Science (à partir de 1990) <LI>Conference Proceedings Citation Index - Social Science & Humanities (à partir de 1990)  <LI>Science Citation Index Expanded(TM)  (à partir de 1899) <LI>Social Sciences Citation Index®  (à partir de 1898) </UL>"]
    expect(database.french_coverage).to eq [""]
    expect(database.french_conditions).to eq ["L'utilisation de cette ressource est limitée aux membres de la communauté universitaire et aux usagers se trouvant sur place, c'est-à-dire dans une bibliothèque de la University of Alberta. Il est interdit d'utiliser cette ressource à des fins autres que la recherche ou l'enseignement individuel et non commercial. Il est également interdit d'effectuer le téléchargement systématique du contenu de cette ressource ou d'en retirer des quantités substantielles d'information par d'autres moyens."]
    expect(database.french_primary_url).to eq ["http://isiknowledge.com/wos"]
    expect(database.french_primary_url_type).to eq ["Accès"]
    expect(database.french_sponsor).to eq [""]
    expect(database.ccid_authentication).to eq ["0"]
    expect(database.publish).to eq ["1"]
    expect(database.subject_id).to eq [""]
    expect(database.record_id).to eq [""]
    expect(database.rank).to eq [""]
    expect(database.description).to eq [""]
    expect(database.subject_id_redundant).to eq [""]
    expect(database.subject).to eq [""]
    expect(database.display_single_search).to eq [""]
  end

  it "should have the fields tagged for solr indexing" do
    expect(database.to_solr["id_tesim"]).to eq database.id
    expect(database.to_solr["core_tesim"]).to eq database.core
    expect(database.to_solr["db_display_tesim"]).to eq database.db_display
    expect(database.to_solr["language_tesim"]).to eq database.language
    expect(database.to_solr["resource_type_tesim"]).to eq database.resource_type
    expect(database.to_solr["conditions_of_use_tesim"]).to eq database.conditions_of_use
    expect(database.to_solr["title_tesim"]).to eq database.title
    expect(database.to_solr["search_title_tesim"]).to eq database.search_title
    expect(database.to_solr["software_tesim"]).to eq database.software
    expect(database.to_solr["branding_tesim"]).to eq database.branding
    expect(database.to_solr["ua_only_tesim"]).to eq database.ua_only
    expect(database.to_solr["new_tesim"]).to eq database.new
    expect(database.to_solr["user_contact_tesim"]).to eq database.user_contact
    expect(database.to_solr["local_access_info_tesim"]).to eq database.local_access_info
    expect(database.to_solr["abstract_tesim"]).to eq database.abstract
    expect(database.to_solr["coverage_tesim"]).to eq database.coverage
    expect(database.to_solr["url_tesim"]).to eq database.url
    expect(database.to_solr["conditions_tesim"]).to eq database.conditions
    expect(database.to_solr["date_added_old_tesim"]).to eq database.date_added_old
    expect(database.to_solr["date_updated_old_tesim"]).to eq database.date_updated_old
    expect(database.to_solr["author_tesim"]).to eq database.author
    expect(database.to_solr["contributor_tesim"]).to eq database.contributor
    expect(database.to_solr["unit_library_tesim"]).to eq database.unit_library
    expect(database.to_solr["comments_tesim"]).to eq database.comments
    expect(database.to_solr["single_search_id_tesim"]).to eq database.single_search_id
    expect(database.to_solr["primary_url_tesim"]).to eq database.primary_url
    expect(database.to_solr["primary_url_type_tesim"]).to eq database.primary_url_type
    expect(database.to_solr["supp_info_tesim"]).to eq database.supp_info
    expect(database.to_solr["order_title_tesim"]).to eq database.order_title
    expect(database.to_solr["cdrom_tesim"]).to eq database.cdrom
    expect(database.to_solr["concurrent_limits_tesim"]).to eq database.concurrent_limits
    expect(database.to_solr["short_description_tesim"]).to eq database.short_description
    expect(database.to_solr["sponsor_tesim"]).to eq database.sponsor
    expect(database.to_solr["stats_link_tesim"]).to eq database.stats_link
    expect(database.to_solr["vendor_link_tesim"]).to eq database.vendor_link
    expect(database.to_solr["vendor_id_tesim"]).to eq database.vendor_id
    expect(database.to_solr["open_url_tesim"]).to eq database.open_url
    expect(database.to_solr["open_url_date_tesim"]).to eq database.open_url_date
    expect(database.to_solr["date_added_tesim"]).to eq database.date_added
    expect(database.to_solr["date_updated_tesim"]).to eq database.date_updated
    expect(database.to_solr["error_message_tesim"]).to eq database.error_message
    expect(database.to_solr["loishole_logo_tesim"]).to eq database.loishole_logo
    expect(database.to_solr["french_title_tesim"]).to eq database.french_title
    expect(database.to_solr["french_order_title_tesim"]).to eq database.french_order_title
    expect(database.to_solr["french_short_description_tesim"]).to eq database.french_short_description
    expect(database.to_solr["french_supp_info_tesim"]).to eq database.french_supp_info
    expect(database.to_solr["french_user_contact_tesim"]).to eq database.french_user_contact
    expect(database.to_solr["french_local_access_info_tesim"]).to eq database.french_local_access_info
    expect(database.to_solr["french_abstract_tesim"]).to eq database.french_abstract
    expect(database.to_solr["french_coverage_tesim"]).to eq database.french_coverage
    expect(database.to_solr["french_conditions_tesim"]).to eq database.french_conditions
    expect(database.to_solr["french_primary_url_tesim"]).to eq database.french_primary_url
    expect(database.to_solr["french_primary_url_type_tesim"]).to eq database.french_primary_url_type
    expect(database.to_solr["french_sponsor_tesim"]).to eq database.french_sponsor
    expect(database.to_solr["ccid_authentication_tesim"]).to eq database.ccid_authentication
    expect(database.to_solr["publish_tesim"]).to eq database.publish
    expect(database.to_solr["subject_id_tesim"]).to eq database.subject_id
    expect(database.to_solr["record_id_tesim"]).to eq database.record_id
    expect(database.to_solr["rank_tesim"]).to eq database.rank
    expect(database.to_solr["description_tesim"]).to eq database.description
    expect(database.to_solr["subject_id_redundant_tesim"]).to eq database.subject_id_redundant
    expect(database.to_solr["subject_tesim"]).to eq database.subject
    expect(database.to_solr["display_single_search_tesim"]).to eq database.display_single_search
  end
end
