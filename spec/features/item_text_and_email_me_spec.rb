require 'rails_helper'

RSpec.describe 'Item can be sent to a user', type: :feature do
  scenario 'Item can be emailed to a user' do
    VCR.use_cassette('item_email_text_me') do
      visit '/catalog/1002481'

      within('.show-tools') do
        click_link 'Email this'
      end

      fill_in 'to', with: 'test@test.ca'
      fill_in 'message', with: 'test message'
      expect { click_button 'Send'; expect(page).to have_content 'Email Sent' }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  scenario 'Item can be texted to a user' do
    VCR.use_cassette('item_email_text_me') do
      visit '/catalog/1002481'

      within('.show-tools') do
        click_link 'Text this'
      end

      fill_in 'to', with: '1234567890'
      select 'Bell', from: 'carrier'
      expect { click_button 'Send'; expect(page).to have_content 'SMS Sent' }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
