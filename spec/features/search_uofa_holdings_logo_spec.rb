require 'rails_helper'

RSpec.describe 'Search results UofA holdings logo', type: :feature do
  scenario 'Search results have logo if UofA holding' do
    visit '/'

    fill_in 'q', with: ' '
    click_button 'search'

    click_on 'Library'
    within('.blacklight-location_tesim') do
      click_on SYMPHONY_LIBRARY_LOCATIONS[:uainternet]
    end

    page.all('#documents .document').each do |element|
      expect(element).to have_css("img[src*='ualib-logo.png']")
    end
  end

  scenario 'Search results do not have logo if not UofA holding' do
    visit '/'

    fill_in 'q', with: ' '
    click_button 'search'

    click_on 'Library'
    within('.blacklight-location_tesim') do
      click_on SYMPHONY_LIBRARY_LOCATIONS[:grmacewan]
    end

    page.all('#documents .document').each do |element|
      expect(element).not_to have_css("img[src*='ualib-logo.png']")
    end
  end
end
