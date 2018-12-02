shared_examples "non-admin game cell" do
  it 'does not show a score link and complete button' do
    visit league_path(league)

    expect(page).to have_content(league.name)
    expect(page).to_not have_button('Complete Game')
    expect(page).to_not have_link('Score Game')
  end
end
