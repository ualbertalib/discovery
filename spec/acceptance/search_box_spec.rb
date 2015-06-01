require_relative '../spec_helper'

include ApplicationURL

describe 'home page' do
  include Capybara::DSL

  it "provides a search box" do
    Capybara.run_server = false
    Capybara.current_driver = :selenium
    Capybara.app_host = URL
    visit '/'
    fill_in 'q', with: "Global Warming"
    click_button 'search'
    expect(current_path).to eq "/results"
   end

end
