require 'rails_helper'

RSpec.describe BackupLocation, type: :model do
  subject do
    described_class.new(
      short_code: 'UASCITECH',
      name: 'University of Alberta Cameron - Science & Technology',
      url: 'https://www.library.ualberta.ca/locations/cameron'
    )
  end

  describe 'Properties' do
    it { is_expected.to have_attributes(short_code: 'UASCITECH') }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:backup_library) }
  end
end
