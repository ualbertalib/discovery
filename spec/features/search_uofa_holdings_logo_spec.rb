require 'rails_helper'

RSpec.describe 'Search results UofA holdings logo', type: :feature do
  scenario 'Search results have logo if UofA holding' do
    visit '/'

    fill_in 'q', with: ' '
    click_button 'search'

    click_on 'Library'
    within('.blacklight-location_tesim') do
      click_on Location.find_by(short_code: :uainternet).name
    end

    page.all('#documents .document').each do |element|
      expect(element).to have_css("img[src*='ualib-logo-green']")
    end
  end

  scenario 'Search results do not have logo if not UofA holding' do
    visit '/'

    fill_in 'q', with: ' '
    click_button 'search'

    click_on 'Library'
    within('.blacklight-location_tesim') do
      click_on Location.find_by(short_code: :grmacewan).name
    end

    page.all('#documents .document').each do |element|
      expect(element).not_to have_css("img[src*='ualib-logo-green']")
    end
  end

  scenario 'Search results have logo if a holding is from both UofA and another location' do
    visit '/'

    fill_in 'q', with: ' '
    click_button 'search'

    click_on 'Library'
    within('.blacklight-location_tesim') do
      click_on Location.find_by(short_code: :uainternet).name
    end

    within('.blacklight-location_tesim') do
      click_on Location.find_by(short_code: :grmacint).name
    end

    page.all('#documents .document').each do |element|
      expect(element).to have_css("img[src*='ualib-logo-green']")
    end
  end
end
