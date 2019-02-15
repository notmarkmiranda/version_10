require 'csv'
require 'net/http'
require 'uri'

desc "import mike cassano's league"
task import_mike_cassano: [:environment] do
  first_season  = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vQsxani6LWbWj1o1LzK8U--98RnBOP5QhIfhSxdkls-8vzUhkPyGlT36prttjrm9dykS2U1680k_QOA/pub?gid=0&single=true&output=csv')
  second_season = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vQsxani6LWbWj1o1LzK8U--98RnBOP5QhIfhSxdkls-8vzUhkPyGlT36prttjrm9dykS2U1680k_QOA/pub?gid=842704448&single=true&output=csv')
  third_season  = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vQsxani6LWbWj1o1LzK8U--98RnBOP5QhIfhSxdkls-8vzUhkPyGlT36prttjrm9dykS2U1680k_QOA/pub?gid=446497304&single=true&output=csv')
  fourth_season = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vQsxani6LWbWj1o1LzK8U--98RnBOP5QhIfhSxdkls-8vzUhkPyGlT36prttjrm9dykS2U1680k_QOA/pub?gid=1132691613&single=true&output=csv')

  all_seasons_csvs = [
    first_season,
    second_season,
    third_season,
    fourth_season
  ]

  NUMBER_OF_SEASONS = all_seasons_csvs.count

  users = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vQsxani6LWbWj1o1LzK8U--98RnBOP5QhIfhSxdkls-8vzUhkPyGlT36prttjrm9dykS2U1680k_QOA/pub?gid=607317098&single=true&output=csv')

  users = create_users(Net::HTTP.get(users))

  @csvs = all_seasons_csvs.map do |season|
    Net::HTTP.get(season)
  end

  admin_user = User.find_or_create_by(email: 'markmiranda51@gmail.com')
  admin_user.update(password: 'password')

  league = League.find_or_create_by(name: 'Mike Cassano\'s Super Fun League', location: 'Denver, Colorado')
  league.update(user_id: admin_user.id, privated: false)
  puts "Created #{league.name}!"

  create_memberships(users.reject { |user| user == admin_user }, league)

  seasons_to_create = difference_in_seasons(league.seasons_count)

  unless seasons_to_create.zero?
    seasons_to_create.times do
      league.seasons.create!
    end
  end

  seasons = league.seasons
  seasons.update_all(active: false, completed: true)
  seasons.last.update(active: true, completed: false)

  seasons.each_with_index do |season, x|
    parse_csv(season, @csvs[x])
  end
end

def create_users(users)
  all_users = []
  CSV.parse(users, { row_sep: :auto, headers: :first_row, encoding: 'bom|utf-8', header_converters: :symbol }) do |row|
    first_name, last_name = row[:person].split

    user = User.find_or_initialize_by(email: row[:email], first_name: first_name, last_name: last_name)
    user.password = SecureRandom.hex
    user.save!
    all_users << user
    puts "#{user.full_name} created!"
  end
  all_users
end

def create_memberships(users, league)
  users.each do |user|
    user.memberships.create!(league: league, role: 0)
    puts "Created membership for #{user.full_name} as non-admin!"
  end
end

def difference_in_seasons(seasons_count)
  NUMBER_OF_SEASONS - seasons_count
end

def parse_csv(season, csv)
  CSV.parse(csv, { row_sep: :auto, headers: :first_row, encoding: 'bom|utf-8', header_converters: :symbol }) do |row|
    first_name, last_name = row[:person].split
    date = Date.strptime(row[:date], '%m/%d/%Y')

    user = User.find_by(first_name: first_name, last_name: last_name)
    game = season.games.find_or_create_by(date: date, buy_in: 15, completed: true)
    player = game.players.find_or_create_by(user_id: user.id, finishing_place: row[:place], additional_expense: row[:additional], score: row[:score])

    puts "#{player.user_full_name} finished #{player.finishing_place.ordinalize} in game ##{game.id} on #{game.formatted_date}"
  end
end
