require 'spec_helper'

describe CatalogHelper do
  describe '#ual_electronic_access_url' do
    it 'should use proxy if not Free Access' do
      location = []
      url = 'https://example.com'
      expect(helper.ual_electronic_access_url(location, url)).to include Rails.application.config.proxy
      expect(helper.ual_electronic_access_url(location, url)).to include url
    end

    it 'should not use proxy if Free Access' do
      location = ['Free Access']
      url = 'https://example.com'
      expect(helper.ual_electronic_access_url(location, url)).not_to include Rails.application.config.proxy
      expect(helper.ual_electronic_access_url(location, url)).to eq url
    end
  end

  describe '#database_electronic_access_url' do
    it 'should use proxy if instructed' do
      document = {}
      document['enableproxy_tesim'] = '1'
      document['url_tesim'] = ['https://example.com']
      expect(helper.database_electronic_access_url(document)).to include Rails.application.config.proxy
      expect(helper.database_electronic_access_url(document)).to include document['url_tesim'].first
    end

    it 'should not use proxy if not instructed' do
      document = {}
      document['enableproxy_tesim'] = '0'
      document['url_tesim'] = ['https://example.com']
      expect(helper.database_electronic_access_url(document)).not_to include Rails.application.config.proxy
      expect(helper.database_electronic_access_url(document)).to eq document['url_tesim'].first
    end
  end

  describe '#libguides_icons' do
    it 'should get icon hashes for iterating on' do
      document = {}
      document['icons_tesim'] = ["\n    \n      6665\n      165\n      ualib-logo.png\n      licensed for  U of A\n      https://www.library.ualberta.ca/about-us/policies/restricted-resource-info\n \
              11710698\n      6665\n      \n    \n    \n      15484\n      165\n      cou-user.png\n      User Registration Required\n \
              https://www.library.ualberta.ca/about-us/policies/conditions-of-use/registration-required\n      11710698\n      15484\n \
                 \n    \n    \n      15485\n      165\n      cou-sign-in.png\n      CCID Login Required\n      https://www.library.ualberta.ca/about-us/policies/conditions-of-use/restricted\n \
              11710698\n      15485\n      \n    \n  "]
      icons = [
        { id: '6665', site_id: '165', file: 'ualib-logo.png', description: 'licensed for  U of A', url: 'https://www.library.ualberta.ca/about-us/policies/restricted-resource-info' },
        { id: '15484', site_id: '165', file: 'cou-user.png', description: 'User Registration Required',
          url: 'https://www.library.ualberta.ca/about-us/policies/conditions-of-use/registration-required' },
        { id: '15485', site_id: '165', file: 'cou-sign-in.png', description: 'CCID Login Required', url: 'https://www.library.ualberta.ca/about-us/policies/conditions-of-use/restricted' }
      ]
      expect(helper.libguides_icons(document)).to eq icons
    end
  end
end
