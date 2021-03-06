class Game < ApplicationRecord
  validates :date, presence: true
  belongs_to :season
  has_many :players

  delegate :count, to: :players, prefix: true
  delegate :league, to: :season
  scope :descending_by_date, -> { order('date') }

  def available_players
    all_users = league.memberships.where(status: :approved).map(&:user)
    available_users = (all_users - players.map(&:user)).sort_by(&:full_name)
    available_users.collect { |user| [user.full_name, user.id] }
  end

  def can_be_completed?
    not_completed? && has_enough_players? && all_players_finished?
  end

  def can_be_uncompleted?
    completed? && has_enough_players?
  end

  def complete!
    return if completed
    finish_all_players
    update(completed: true)
  end

  def formatted_date
    date.strftime('%B %Y')
  end

  def formatted_full_date
    date.strftime('%B %-e, %Y')
  end

  def has_players?
    players.any?
  end

  def in_the_future?
    date.future? || not_completed?
  end

  def not_completed?
    !completed?
  end

  def not_enough_players?
    players_count < 2
  end

  def player_in_place_full_name(place)
    players.find_by(finishing_place: place)&.user_full_name
  end

  def score_game
    return nil if players.empty?
    score_players = lambda { |player| player.score_player }
    players.each(&score_players)
  end

  def total_pot
    normal_pot = (buy_in * players_count)
    additional_pot = players.map(&:additional_expense).compact.sum
    normal_pot + additional_pot
  end

  def uncomplete!
    return if not_completed?
    update(completed: false)
  end

  def winner_full_name
    player_in_place_full_name(1)
  end

  def season_league_season_number
    league.season_number(season)
  end

  private

  def all_players_finished?
    players.map(&:finished_at).all?
  end

  def finish_all_players
    players.in_finishing_order.each_with_index do |player, index|
      player.finish_player_and_calculate_score(index + 1)
    end
  end

  def has_enough_players?
    players_count > 1
  end
end
