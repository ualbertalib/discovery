require 'rails_helper'

RSpec.describe RCRFSpecialRequest, type: :model do
  subject do
    described_class.new(
      name: 'Jane Doe',
      email: 'jane_doe@ualberta.ca',
      title: 'The death of Archie',
      item_url: 'https://library.ualberta.ca/catalog/8081552',
      notes: 'Would like to request a visit to view this item on January 1st around 1 PM',
      library: 'University of Alberta Augustana'
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

    it 'is not valid without a title' do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a item_url' do
      subject.item_url = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a notes' do
      subject.notes = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a library' do
      subject.library = nil
      expect(subject).to_not be_valid
    end
  end
end
