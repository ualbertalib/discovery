require 'rails_helper'

RSpec.describe 'Item has functioning chained subject linking', type: :feature do
  scenario 'User can view and use subject chain' do
    visit '/catalog/1002481'

    expect(page).to have_text('Shakespeare at the Globe : 1599-1609')
    page.assert_selector('ul.subject-chain-links li', count: 4)
    expect(first('ul.subject-chain-links')).to have_text('Shakespeare, William, 1564-1616 Stage history To 1625')
    expect(first('ul.subject-chain-links')).to have_text('Shakespeare, William, 1564-1616 Technique')
    expect(first('ul.subject-chain-links')).to have_text('Shakespeare, William, 1564-1616 Dramatic production')
    expect(first('ul.subject-chain-links')).to have_text('Globe Theatre (London, England : 1599-1644)')

    within('ul.subject-chain-links') do
      click_on 'Shakespeare, William,'
    end
    expect(page).to have_css('.appliedFilter', text: 'Shakespeare, William,')
    expect(page).to have_text('Shakespeare at the Globe : 1599-1609')

    visit '/catalog/1002481'
    within('ul.subject-chain-links') do
      click_on '1564-1616'
    end
    expect(page).to have_css('.appliedFilter', text: 'Shakespeare, William, 1564-1616')
    expect(page).to have_text('Shakespeare at the Globe : 1599-1609')

    visit '/catalog/1002481'
    within('ul.subject-chain-links') do
      click_on 'To 1625'
    end
    expect(page).to have_css('.appliedFilter', text: 'Shakespeare, William, 1564-1616 To 1625')
    expect(page).to have_text('Shakespeare at the Globe : 1599-1609')
  end
end
