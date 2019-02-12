require 'rails_helper'

describe 'Completing a game requires all players have finished_at' do
  let(:game) { create :game, buy_in: 15 }
  let(:admin) { game.league.user }

  before do
    stub_current_user(admin)
  end

  context 'with all players finished' do
    let!(:second_place_player) do
      create(
        :player,
        game: game,
        finished_at: Time.now,
        finishing_place: nil,
        score: nil,
        additional_expense: 0
      )
    end

    let!(:first_place_player) do
      create(
        :player,
        game: game,
        finished_at: (Time.now + 120),
        finishing_place: nil,
        score: nil,
        additional_expense: 0
      )
    end

    it 'completes the game and gives the players a score and place based on time' do
      visit game_path game

      click_button 'Complete Game'

      expect(page).to have_content("1. #{first_place_player.user_full_name}")
      expect(page).to have_content('Score: 2.738')
      expect(page).to have_content("2. #{second_place_player.user_full_name}")
      expect(page).to have_content('Score: 1.825')
    end
  end

  context 'if one of the players is not finished' do
    let!(:unfinished_player) do
      create(
        :player,
        game: game,
        finished_at: nil,
        finishing_place: nil,
        score: nil,
        additional_expense: 100
      )
    end

    let!(:second_place_player) do
      create(
        :player,
        game: game,
        finished_at: Time.now,
        finishing_place: nil,
        score: nil,
        additional_expense: 0
      )
    end

    let!(:first_place_player) do
      create(
        :player,
        game: game,
        finished_at: (Time.now + 120),
        finishing_place: nil,
        score: nil,
        additional_expense: 0
      )
    end

    it 'should not complete the game or give players a score or place based on time' do
      visit game_path game

      click_button 'Complete Game'

      expect(page).to have_content(unfinished_player.user_full_name)
      expect(page).not_to have_content("2. #{first_place_player.user_full_name}")
      expect(page).not_to have_content('Score: 2.236')
      expect(page).not_to have_content("3. #{second_place_player.user_full_name}")
      expect(page).not_to have_content('Score: 1.677')
    end
  end
end
