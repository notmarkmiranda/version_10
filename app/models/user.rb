class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :email, presence: true, uniqueness: true
  has_many :leagues
  has_many :players
  has_many :memberships

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

  def number_of_leagues_played_in
    leagues_played_in.count
  end

  def owned_leagues
    get_leagues(role: 1)
  end

  def participated_leagues
    get_leagues
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

  def get_leagues(role: 0)
    League
      .joins(:memberships)
      .where('memberships.user_id = ? AND memberships.role = ?', id, role)
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
