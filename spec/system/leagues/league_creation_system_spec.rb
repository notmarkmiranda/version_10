require 'rails_helper'

describe 'League Creation', type: :system do
  it 'creates a new public league and redirects to that league' do
    visit '/leagues/new'

    fill_in :league_name, with: 'Mark Miranda\'s New League'
    find('#private league').set(false)
    click_button 'Create League'

    expect(current_path).to eq(league_path(League.last))
  end

  it 'creates a new private league and redirects to that league'
  it 'does not create a new league without a name and renders the new template'
end
