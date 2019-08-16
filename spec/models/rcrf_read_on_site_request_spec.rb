require 'rails_helper'

RSpec.describe RCRFReadOnSiteRequest, type: :model do
  subject do
    described_class.new(
      name: 'Jane Doe',
      email: 'jane_doe@ualberta.ca',
      viewing_location: 'Bruce Peel Special Collection',
      appointment_date_and_time: 'January 1st at 1 PM',
      title: 'The death of Archie',
      item_url: 'https://library.ualberta.ca/catalog/8081552'
    )
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a email' do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a viewing_location' do
      subject.viewing_location = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a appointment_date_and_time' do
      subject.appointment_date_and_time = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a title' do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a item_url' do
      subject.item_url = nil
      expect(subject).to_not be_valid
    end
  end
end
