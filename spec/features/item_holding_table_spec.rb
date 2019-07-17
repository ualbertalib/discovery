require 'rails_helper'

RSpec.describe 'Item has proper holding table', type: :feature do
  scenario 'Symphony item has proper holding table' do
    VCR.use_cassette('item_symphony_holding_table') do
      visit '/catalog/1002481'

      page.assert_selector('#holdings table td', count: 7)
      expect(first('#holdings table td')).to have_text('Vanguard College')
      expect(first('#holdings table td')).to have_text('call number: PR 3095 B4 1966')
      expect(first('#holdings table td')).to have_text('status: on shelf')
      expect(first('#holdings table td')).to have_text('item type: book')
      expect(first('#holdings table td')).to have_link('Email this', href:  /\/catalog\/email/)
      expect(first('#holdings table td')).to have_link('Text this', href:  /\/catalog\/sms/)
      expect(first('#holdings table td')).to have_css("a[href='http://catalogue.library.ualberta.ca/sirsi/index.cfm?location=VANGUARD']")
    end
  end

  scenario 'Sfx item has proper holding table' do
    VCR.use_cassette('item_sfx_holding_table') do
      visit '/catalog/954921333007'

      page.assert_selector('#holdings table td', count: 5)
      expect(first('#holdings table td')).to have_link('Business Source Complete', href:  'http://login.ezproxy.library.ualberta.ca/login?url=https://search.ebscohost.com/direct.asp?db=bth&jn=AMJ&scope=site')
      expect(first('#holdings table td')).to have_text('coverage: Available from 1963.')
      expect(first('#holdings table td')).to have_css("iframe[src='https://tal.scholarsportal.info/alberta/sfx/?tag=EBSCOhost_LHCADL']")
    end
  end

  scenario 'Kule item has proper holding table' do
    VCR.use_cassette('item_kule_holding_table') do
      visit '/catalog/kule697990578'

      page.assert_selector('#holdings table td', count: 1)
      expect(first('#holdings table td')).to have_text('Kule Folklore Centre')
      expect(first('#holdings table td')).to have_text('call number: UF2001.072.b002')
      expect(first('#holdings table td')).to have_text('status: Read On Site')
      expect(first('#holdings table td')).to have_link('Email this', href:  /\/catalog\/email/)
      expect(first('#holdings table td')).to have_link('Text this', href:  /\/catalog\/sms/)
      expect(first('#holdings table td')).to have_css("a[href='https://www.ualberta.ca/kule-folklore-centre/']")
    end
  end

  scenario 'Requestable items have proper holding tables' do
    VCR.use_cassette('item_requestable_holding_table') do
      visit '/catalog/10068'

      page.assert_selector('#holdings table td', count: 1)
      expect(first('#holdings table td')).to have_text('University of Alberta Research and Collections Resource Facility')
      expect(first('#holdings table td')).to have_text('call number: LB 01 459 (1 reel)')
      expect(first('#holdings table td')).to have_text('status: on shelf')
      expect(first('#holdings table td')).to have_text('item type: microform')
      expect(first('#holdings table td')).to have_link('Request this', href:  /\/rcrf_special_requests\/new/)
      expect(first('#holdings table td')).to have_link('Email this', href:  /\/catalog\/email/)
      expect(first('#holdings table td')).to have_link('Text this', href:  /\/catalog\/sms/)
      expect(first('#holdings table td')).to have_css("a[href='http://catalogue.library.ualberta.ca/sirsi/index.cfm?location=UARCRF']")

      visit '/catalog/1000719'

      page.assert_selector('#holdings table td', count: 1)
      expect(first('#holdings table td')).to have_text('University of Alberta Research and Collections Resource Facility')
      expect(first('#holdings table td')).to have_text('call number: F 1465.3 G6 M296 1988')
      expect(first('#holdings table td')).to have_text('status: Read On Site')
      expect(first('#holdings table td')).to have_text('item type: no loan')
      expect(first('#holdings table td')).to have_link('Request this', href:  /\/rcrf_read_on_site_requests\/new/)
      expect(first('#holdings table td')).to have_link('Email this', href:  /\/catalog\/email/)
      expect(first('#holdings table td')).to have_link('Text this', href:  /\/catalog\/sms/)
      expect(first('#holdings table td')).to have_css("a[href='http://catalogue.library.ualberta.ca/sirsi/index.cfm?location=UARCRF']")

      visit '/catalog/1001675'

      page.assert_selector('#holdings table td', count: 2)
      expect(first('#holdings table td')).to have_text('University of Alberta Bruce Peel Special Collections')
      expect(first('#holdings table td')).to have_text('call number: TL 789.3 S917 1987')
      expect(first('#holdings table td')).to have_text('status: Read On Site')
      expect(first('#holdings table td')).to have_text('item type: no loan')
      expect(first('#holdings table td')).to have_link('Request this', href:  /\/bpsc_read_on_site_requests\/new/)
      expect(first('#holdings table td')).to have_link('Email this', href:  /\/catalog\/email/)
      expect(first('#holdings table td')).to have_link('Text this', href:  /\/catalog\/sms/)
      expect(first('#holdings table td')).to have_css("a[href='http://catalogue.library.ualberta.ca/sirsi/index.cfm?location=UASPCOLL']")
    end
  end
end
