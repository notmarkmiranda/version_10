class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :email, presence: true, uniqueness: true
  has_many :owned_leagues, foreign_key: 'user_id', class_name: 'League'
  has_many :players

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def attendance(season=nil)
    attended, out_of = get_attendance(season)
    return [0, 0] if attended&.zero? || out_of&.zero?
    [attended, out_of]
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def not_part_of_league?(league)
    !part_of_league?(league)
  end

  def number_of_leagues_played_in
    leagues_played_in.count
  end

  def part_of_league?(league)
    participated_leagues.include?(league) || owned_leagues.include?(league)
  end

  def participated_leagues
    League.joins(:players)
      .where.not('leagues.user_id = ?', id)
      .where('players.user_id = ?', id).uniq
  end

  def winner_calculation(season=nil)
    won, out_of = get_winners(season)
    return [0, 0] if won&.zero? || out_of&.zero?
    [won, out_of]
  end

  private

  def get_attendance(season=nil)
    return [
      season.games.joins(:players).where('players.user_id = ?', id).count,
      season.games_count
    ] if season
    [players.count, leagues_played_in_count]
  end

  def get_winners(season=nil)
    return [
      season.players.where(finishing_place: 1, user_id: id).count,
      season.players.where(user_id: id).count
    ] if season
    [players.where(finishing_place: 1).count, players.count]
  end

  def leagues_played_in
    players.map(&:league).uniq
  end

  def leagues_played_in_count
    leagues_played_in.map(&:games).flatten.count
  end
end
