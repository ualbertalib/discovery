require_relative '../../spec_helper'

describe 'home page' do
  include Capybara::DSL

  it "provides a search box" do
    visit '/'
    fill_in 'q', with: "Global Warming"
    click_button 'search'
    expect(current_path).to eq "/results"
   end
end
