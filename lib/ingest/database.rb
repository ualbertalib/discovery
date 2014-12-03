require "nokogiri"

class Database

  attr_accessor :id, :core, :display, :language, :resource_type, :conditions_of_use, :title, :search_title, :software, :branding, :ua_only, :new, :user_contact, :local_access_info, :abstract, :coverage, :url, :conditions, :date_added_old, :date_updated_old, :author, :contributor, :unit_library , :comments, :single_search_id, :primary_url, :primary_url_type, :supp_info, :order_title, :cdrom, :concurrent_limits, :short_description, :sponsor, :stats_link, :vendor_link, :vendor_id, :open_url, :open_url_date, :date_added, :date_updated, :error_message, :loishole_logo, :french_title, :french_order_title, :french_short_description, :french_supp_info, :french_user_contact, :french_local_access_info, :french_abstract, :french_coverage, :french_conditions, :french_primary_url, :french_primary_url_type, :french_sponsor, :ccid_authentication, :publish, :subject_id, :record_id, :rank, :description, :subject_id_redundant, :subject, :display_single_search, :format

  def parse csv
    @id, @core, @display, @language, @resource_type, @conditions_of_use, @title, @search_title, @software, @branding, @ua_only, @new, @user_contact, @local_access_info, @abstract, @coverage, @url, @conditions, @date_added_old, @date_updated_old, @author, @contributor, @unit_library , @comments, @single_search_id, @primary_url, @primary_url_type, @supp_info, @order_title, @cdrom, @concurrent_limits, @short_description, @sponsor, @stats_link, @vendor_link, @vendor_id, @open_url, @open_url_date, @date_added, @date_updated, @error_message, @loishole_logo, @french_title, @french_order_title, @french_short_description, @french_supp_info, @french_user_contact, @french_local_access_info, @french_abstract, @french_coverage, @french_conditions, @french_primary_url, @french_primary_url_type, @french_sponsor, @ccid_authentication, @publish, @subject_id, @record_id, @rank, @description, @subject_id_redundant, @subject, @display_single_search = csv.split("|")
  end

  def to_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.root {
        xml.databases {
          xml.database {
            xml.id_ @id
            xml.core @core
            xml.db_display @display
            xml.language @language
            xml.resource_type @resource_type
            xml.conditions_of_use @conditions_of_use
            xml.title @title
            xml.search_title @search_title
            xml.software @software
            xml.branding @branding
            xml.ua_only @ua_only
            xml.new @new
            xml.user_contact @user_contact
            xml.local_access_info @user_access_info
            xml.abstract @abstract
            xml.coverage @coverage
            xml.url @url
            xml.conditions @conditions
            xml.date_added_old @date_added_old
            xml.date_updated_old @date_updated_old
            xml.author @author
            xml.contributor @contributor
            xml.unit_library @unit_library
            xml.comments @comments
            xml.single_search_id @single_search_id
            xml.primary_url @primary_url
            xml.primary_url_type @primary_url_type
            xml.supp_info @supp_info
            xml.order_title @order_title
            xml.cdrom @cdrom
            xml.concurrent_limits @concurrent_limits
            xml.short_description @short_description
            xml.sponsor @sponsor
            xml.stats_link @stats_link
            xml.vendor_link @vendor_link
            xml.vendor_id @vendor_id
            xml.open_url @open_url
            xml.open_url_date @open_url_date
            xml.date_added @date_added
            xml.date_updated @date_updated
            xml.error_message @error_message
            xml.loishole_logo @loishole_logo
            xml.french_title @french_title
            xml.french_order_title @french_order_title
            xml.french_short_description @french_short_description
            xml.french_supp_info @french_supp_info
            xml.french_user_contact @french_user_contact
            xml.french_local_access_info @french_local_access_info
            xml.french_abstract @french_abstract
            xml.french_coverage @french_coverage
            xml.french_conditions @french_conditions
            xml.french_primary_url @french_primary_url
            xml.french_primary_url_type @french_primary_url_type
            xml.french_sponsor @french_sponsor
            xml.ccid_authentication @ccid_authentication
            xml.publish @publish
            xml.subject_id @subject_id
            xml.record_id @record_id
            xml.rank @rank
            xml.description @description
            xml.subject_id_redundant @subject_id_redundant
            xml.subject @subject
            xml.display_single_search @display_single_search
            xml.type "Database"
            xml.electronic true
          }
        }
      }
    end
    builder.doc.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML).gsub("\n", "").gsub('""', '"')
  end
end
