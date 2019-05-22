class UserCreator
  attr_reader :user, :game_id, :requestor 

  def initialize(user_params, game_id, requestor, role=nil)
    @user = User.new(user_params)
    @game_id = game_id
    @requestor = requestor
  end

  def save
    user.password = SecureRandom.hex
    return create_membership if user.save
    false
  end

  private

  def create_membership
    game.league.memberships.create!(user: user, role: 0, status: "approved", requestor: requestor)
    user
  end

  def game
    @game ||= Game.find game_id
  end
end
