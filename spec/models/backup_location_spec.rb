require 'rails_helper'

RSpec.describe BackupLocation, type: :model do
  subject do
    described_class.new(
      short_code: 'UASCITECH',
      old_short_code: 'uascitech',
      name: 'University of Alberta Cameron - Science & Technology',
      url: 'https://www.library.ualberta.ca/locations/cameron'
    )
  end

  describe 'Properties' do
    it { is_expected.to have_attributes(short_code: 'UASCITECH') }
    it { is_expected.to have_attributes(old_short_code: 'uascitech') }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:backup_library) }
  end
end
