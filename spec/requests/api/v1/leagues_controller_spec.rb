require 'rails_helper'

describe 'Api::V1::LeaguesController', type: :request do
  describe 'get#public' do
    subject(:get_public_leagues) { get api_v1_leagues_public_path }

    let!(:private_league) { create(:league, privated: true) }

    it 'returns no leagues' do

      get_public_leagues

      expect(JSON.parse(response.body)).to eq([])
      expect(response.status).to eq(200)
    end

    it 'returns a single public league' do
      public_league = create(:league, privated: false)
      expected_return = {
        "id" => public_league.id,
        "name" => public_league.name,
        "games_count" => public_league.games_count,
        "average_players_per_game" => public_league.average_players_per_game,
        "average_pot_size" => public_league.average_pot_size
      }

      get_public_leagues

      expect(JSON.parse(response.body).first).to eq(expected_return)
      expect(response.status).to eq(200)
    end

    it 'returns multiple public leagues' do
      public_leagues = create_list(:league, 2, privated: false)

      expected_return = public_leagues.sort_by(&:name).map do |league|
                          {
                            "id" => league.id,
                            "name" => league.name,
                            "games_count" => league.games_count,
                            "average_players_per_game" => league.average_players_per_game,
                            "average_pot_size" => league.average_pot_size
                          }
                        end

      get_public_leagues

      expect(JSON.parse(response.body)).to match(expected_return)
      expect(response.status).to eq(200)
    end
  end
end
