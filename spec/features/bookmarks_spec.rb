# frozen_string_literal: true

RSpec.describe 'Bookmarks', type: :feature do
  describe 'navigating from the homepage' do
    it 'has a link to the history page' do
      visit '/'
      fill_in 'q', with: 'Shakespeare'
      click_button 'search'
      click_link 'Go to bookmarks'
      expect(page).to have_content 'You have no bookmarks'
    end
  end

  it 'add and remove bookmarks from search results' do
    visit '/'
    fill_in 'q', with: 'Shakespeare'
    click_button 'search'
    within first('div.document') do
      check 'Bookmark'
      expect(page).to have_content 'In Bookmarks'
    end

    fill_in 'q', with: 'Shakespeare'
    click_button 'search'
    within first('div.document') do
      uncheck 'In Bookmarks'
      expect(page).to have_content 'Bookmark'
    end
  end

  it 'adds and delete bookmarks from the show page' do
    VCR.use_cassette('item_result') do
      visit 'catalog/1001523'
      expect(page).to have_content 'Bookmark'
      check 'Bookmark'
      expect(page).to have_content 'In Bookmarks'
      uncheck 'In Bookmarks'
      expect(page).to have_content 'Bookmark'
    end
  end

  it 'cites items in current bookmarks page' do
    VCR.use_cassette('item_result') do
      visit 'catalog/1001523' # Shakespeare : a historical and critical study with annotated texts of twenty-one plays
      check 'Bookmark'
    end

    VCR.use_cassette('item to bookmark') do
      visit 'catalog/1002481' # Shakespeare at the Globe : 1599-1609 / Bernard Beckerman
      check 'Bookmark'
    end

    visit '/bookmarks?per_page=1'
    expect(page).to have_content 'Shakespeare at the Globe'
    expect(page).not_to have_content 'Shakespeare : a historical and critical study with annotated texts of twenty-one plays'
  end

  it 'emails items in current bookmarks page' do
    VCR.use_cassette('item_result') do
      visit 'catalog/1001523' # Shakespeare : a historical and critical study with annotated texts of twenty-one plays
      check 'Bookmark'
    end

    VCR.use_cassette('item to bookmark') do
      visit 'catalog/1002481' # Shakespeare at the Globe : 1599-1609 / Bernard Beckerman
      check 'Bookmark'
    end

    visit '/bookmarks'
    click_on 'Email'
    fill_in 'to', with: 'user@example.com'
    fill_in 'message', with: 'testing bookmarks email'
    click_button 'Send'
    expect(page).to have_content 'Email Sent'
  end
end
