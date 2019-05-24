require 'rails_helper'

RSpec.describe 'Electronic Resources Links', type: :feature do
  scenario 'User visits a database' do
    VCR.use_cassette('click_here_result') do
      visit 'catalog/11711195'
      expect(page).to have_text('Physical Education Index')
      expect(page).to have_link('Click Here for Access')
      new_window = window_opened_by do
        click_link 'Click Here for Access'
      end
      within_window new_window do
        sleep 3
        expect(page).to have_text('Sports Medicine & Education Index')
      end
      new_window.close
    end
  end

  scenario 'User visits a free access resource' do
    VCR.use_cassette('free_access_result') do
      visit 'catalog/1006311'
      expect(page).to have_text("Règlements, usages et discipline du diocèse de Saint-Albert : promulgués, en l'année 1903 ")
      expect(page).to have_link('Click Here for University of Alberta Access (Free Access)')
      new_window = window_opened_by { click_link 'Click Here for University of Alberta Access (Free Access)' }
      within_window new_window do
        sleep 1
        expect(page).to have_text('Peel 2692')
      end
      new_window.close
    end
  end

  scenario 'User visits a UAL Access resource' do
    VCR.use_cassette('ual_access_result') do
      visit 'catalog/1008878'
      expect(page).to have_text('Psychology in business relations')
      expect(page).to have_link('Click Here for University of Alberta Access')
      expect(page).to_not have_link('Concordia University of Edmonton Access')
      new_window = window_opened_by { click_link 'Click Here for University of Alberta Access' }
      within_window new_window do
        sleep 10
        expect(page).to have_text('Psychology in business relations')
      end
      new_window.close
    end
  end

  scenario 'User visits a finding aid resource' do
    VCR.use_cassette('finding_aid_result') do
      visit 'catalog/4072071'
      expect(page).to have_text('Church Missionary Society archive. Section III, Central records [microform]')
      expect(page).to have_link('Finding aid, pt. 1-5')
      expect(page).to have_link('Finding aid, pt. 6-12')
      expect(page).to have_link('Finding aid, pt. 13-14')
      expect(page).to have_link('Finding aid, pt. 15-18')
      expect(page).to have_link('Finding aid, pt. 19')
      expect(page).to have_link('Finding aid, pt. 20')
      expect(page).to have_link('Finding aid, pt. 21')
      expect(page).to have_link('Finding aid, pt. 22')
      new_window = window_opened_by { click_link 'Finding aid, pt. 1-5' }
      within_window new_window do
        sleep 1
        expect(page).to have_title('CHURCH MISSIONARY SOCIETY ARCHIVE, Section III, Parts 1 to 5')
      end
      new_window.close
      new_window = window_opened_by { click_link 'Finding aid, pt. 22' }
      within_window new_window do
        sleep 1
        expect(page).to have_title('CMS III 22')
      end
      new_window.close
    end
  end

  scenario 'User visits an On-campus access resource' do
    VCR.use_cassette('on_campus_result') do
      visit 'catalog/2714245'
      expect(page).to have_text('Milk final estimates ... [electronic resource]')
      expect(page).to have_text('Note: No University of Alberta Access. On-campus access allowed at the following locations:')
      expect(page).to have_link('Alberta Government Library Access')
      new_window = window_opened_by { click_link 'Alberta Government Library Access' }
      within_window new_window do
        sleep 1
        expect(page).to have_text('Milk - Final Estimates')
      end
      new_window.close
    end
  end
end
