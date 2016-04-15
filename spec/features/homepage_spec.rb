require_relative '../spec_helper'

RSpec.feature "Home Page", :type => :feature do
    scenario "welcomes the user" do
      visit "/" # this doesn't work, I think because of the CMS. Going to have to figure out some other solution.
      expect(page).to have_title('University of Alberta Libraries')
      expect(page).to have_content('Search Library Resources')
        # test for presence of all content panes
      expect(page).to have_content('Library Hours & Locations')
      expect(page).to have_content('News & Events')
      expect(page).to have_content('Popular Library Services')
      expect(page).to have_content('Subject Guides')
      expect(page).to have_content('Research Data Management')
      expect(page).to have_content('My Account Login')
    end

  end
