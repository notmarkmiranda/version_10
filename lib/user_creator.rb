class UserCreator
  attr_reader :user, :game_id

  def initialize(user_params, game_id, role=nil)
    @user = User.new(user_params)
    @game_id = game_id
  end

  def save
    user.password = SecureRandom.hex
    return create_membership if user.save
    false
  end

  private

  def create_membership
    game.league.memberships.create!(user: user, role: 0)
    user
  end

  def game
    @game ||= Game.find game_id
  end
end
