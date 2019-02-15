require 'rails_helper'

describe 'League Creation', type: :feature do
  before do
    stub_current_user
    visit '/leagues/new'
  end

  describe 'successful create' do
    before do
      fill_in 'League Name', with: "Mark Miranda's New League"
    end

    it 'creates a new public league and redirects to that league' do
      find('#league_privated').set(false)
      click_button 'Create League'

      expect(current_path).to eq(league_path(League.last))
      expect(page).to have_content "Mark Miranda's New League"
      expect(page).to have_content 'Public league'
    end

    it 'creates a new private league and redirects to that league' do
      find('#league_privated').set(true)
      click_button 'Create League'

      expect(current_path).to eq(league_path(League.last))
      expect(page).to have_content "Mark Miranda's New League"
      expect(page).to have_content 'Private league'
    end
  end

  it 'does not create a new league without a name and renders the new template' do
    click_button 'Create League'

    expect(page).to have_content('Something went wrong')
    # expect(page).to have_current_path(new_league_path)
  end
end
