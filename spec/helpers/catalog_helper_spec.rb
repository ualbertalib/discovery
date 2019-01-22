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
end
