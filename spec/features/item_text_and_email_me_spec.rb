require 'rails_helper'

RSpec.describe 'Item can be sent to a user', type: :feature do
  scenario 'Item can be emailed to a user' do
    VCR.use_cassette('item_email_me') do
      visit '/catalog/1002481'

      within('.show-tools') do
        click_link 'Email this'
      end

      fill_in 'to', with: 'test@test.ca'
      fill_in 'message', with: 'test message'
      click_button 'Send'
      expect(page).to have_content 'Email Sent'
    end
  end

  scenario 'Item can be texted to a user' do
    VCR.use_cassette('item_text_me') do
      visit '/catalog/1002481'

      within('.show-tools') do
        click_link 'Text this'
      end

      fill_in 'to', with: '1234567890'
      select "Bell", from: "carrier"
      click_button 'Send'
      expect(page).to have_content 'SMS Sent'
    end
  end
end
