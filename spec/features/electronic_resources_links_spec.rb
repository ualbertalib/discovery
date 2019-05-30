require 'rails_helper'

RSpec.describe 'Electronic Resources Links', type: :feature do
  scenario 'User visits a database' do
    VCR.use_cassette('click_here_result') do
      visit 'catalog/11711195'
      expect(page).to have_text('Physical Education Index')
      expect(page).to have_link('Click Here for Access', href: 'http://login.ezproxy.library.ualberta.ca/login?url=http://search.proquest.com/physicaleducation/advanced?accountid=14474')
    end
  end

  scenario 'User visits a free access resource' do
    VCR.use_cassette('free_access_result') do
      visit 'catalog/1006311'
      expect(page).to have_text("Règlements, usages et discipline du diocèse de Saint-Albert : promulgués, en l'année 1903 ")
      expect(page).to have_link('Click Here for University of Alberta Access (Free Access)', href: 'http://peel.library.ualberta.ca/cocoon/peel/2692.html')
    end
  end

  scenario 'User visits a UAL Access resource' do
    VCR.use_cassette('ual_access_result') do
      visit 'catalog/1008878'
      expect(page).to have_text('Psychology in business relations')
      expect(page).to have_link('Click Here for University of Alberta Access', href: 'http://login.ezproxy.library.ualberta.ca/login?url=http://gateway.ovid.com/ovidweb.cgi?T=JS&NEWS=N&PAGE=toc&SEARCH=2005-09562.dd&LINKTYPE=asBody&D=psbk')
      expect(page).to_not have_link('Concordia University of Edmonton Access')
    end
  end

  scenario 'User visits a finding aid resource' do
    VCR.use_cassette('finding_aid_result') do
      visit 'catalog/4072071'
      expect(page).to have_text('Church Missionary Society archive. Section III, Central records [microform]')
      expect(page).to have_link('Finding aid, pt. 1-5', href: 'http://www.ampltd.co.uk/digital_guides/cms_section_III_parts_1_to_5/Contents.aspx')
      expect(page).to have_link('Finding aid, pt. 6-12', href: 'http://www.ampltd.co.uk/digital_guides/cms_section_III_parts_6_to_12/Contents.aspx')
      expect(page).to have_link('Finding aid, pt. 13-14', href: 'http://www.ampltd.co.uk/digital_guides/cms_section_III_parts_13_and_14/Contents.aspx')
      expect(page).to have_link('Finding aid, pt. 15-18', href: 'http://www.ampltd.co.uk/digital_guides/cms_section_III_parts_15_to_18/Contents.aspx')
      expect(page).to have_link('Finding aid, pt. 19', href: 'http://www.ampltd.co.uk/digital_guides/cms_section_III_part_19/Contents.aspx')
      expect(page).to have_link('Finding aid, pt. 20', href: 'http://www.ampltd.co.uk/digital_guides/cms_section_III_part_20/Contents.aspx')
      expect(page).to have_link('Finding aid, pt. 21', href: 'http://www.ampltd.co.uk/digital_guides/cms_section_III_part_21/contents.aspx')
      expect(page).to have_link('Finding aid, pt. 22', href: 'http://www.ampltd.co.uk/digital_guides/cms_section_III_part_22/Contents.aspx')
    end
  end

  scenario 'User visits an On-campus access resource' do
    VCR.use_cassette('on_campus_result') do
      visit 'catalog/2714245'
      expect(page).to have_text('Milk final estimates ... [electronic resource]')
      expect(page).to have_text('Note: No University of Alberta Access. On-campus access allowed at the following locations:')
      expect(page).to have_link('Alberta Government Library Access', href: 'http://purl.access.gpo.gov/GPO/LPS31752')
    end
  end
end
