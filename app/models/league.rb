class League < ApplicationRecord
  include StatisticsCompiler

  validates :user, presence: true
  validates :name, presence: true
  belongs_to :user
  has_many :seasons
  has_many :games, -> { order('games.date') }, through: :seasons
  has_many :players, through: :games
  has_many :memberships

  delegate :count, to: :seasons, prefix: true
  delegate :count, to: :players, prefix: true

  after_create_commit :create_first_season
  after_create_commit :create_adminship

  scope :non_private, -> { where(privated: false) }

  def admins
    User
      .joins(:memberships)
      .where('memberships.league_id = ? AND memberships.role = ?', id, 1)
  end

  def current_season
    seasons.find_by(active: true, completed: false) || seasons.last
  end

  def current_season_number
    return nil if seasons.empty?
    (seasons.index(current_season) + 1).to_i
  end

  def games_every_x_weeks
    return nil if no_games? || games_count  == 1
    (weeks - 1) / (games_count - 1)
  end

  def leader_full_name
    return 'No One' if no_one_qualifies?
    league_standings.first.user_full_name
  end

  def most_second_place_finishes
    # max_hash = players.where(finishing_place: 2)
      # .select(:user_id)
      # .group(:user_id)
      # .order('count_id DESC')
      # .count(:id)
    # max_qty  = max_hash.values.max
    # max_ids  = max_hash.select { |k, v| v == max_qty }.keys
    max_ids = []
    return [['Stat not yet available.'], 0] if max_ids.empty?
    # [max_ids.map { |id| User.find(id).full_name}.sort, max_qty]
  end

  def new_game
    current_season.games.new
  end

  def next_game
    date_of_next_game = games
    .where('games.completed = ? AND games.date >= ?', false, Date.today)
    .order('games.date ASC')
    .first
    &.formatted_full_date
    return 'No Scheduled Game' if date_of_next_game.nil?
    date_of_next_game
  end

  def ordered_rankings_full_names
    return [] if no_one_qualifies?
    league_standings
  end

  def privated_text
    privated ? 'Private league' : 'Public league'
  end

  def season_number(season=nil)
    return nil if seasons.empty?
    (seasons.index(season || current_season) + 1).to_i
  end

  def league_standings
    players.rank_league_by_score(current_season)
  end

  private

  def create_adminship
    memberships.create!(user_id: user_id, role: 1, skip_notification: true)
  end

  def create_first_season
    seasons.create!(active: true, completed: false)
  end

  def weeks
    date_array = games.descending_by_date.pluck(:date)
    seconds = date_array.last - date_array.first
    seconds.round / 60.0 / 60 / 24 / 7
  end
end
