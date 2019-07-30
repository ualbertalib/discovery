require 'rails_helper'

RSpec.describe 'Send correction', type: :feature do
  scenario 'A user can send a correction' do
    VCR.use_cassette('send_correction') do
      visit '/catalog/1002481'
      within('.show-tools') do
        click_link 'Send Correction'
      end

      fill_in 'correction[message]', with: 'correction message'
      expect { click_button 'Submit Error, Typo or Suggestion' }
        .to change { ActionMailer::Base.deliveries.count }.by(1)

      expect(page).to have_content 'Thank you! We have received your correction and will be reviewing it soon.'
    end
  end
end
