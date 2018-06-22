require 'csv'
require 'net/http'
require 'uri'

desc "import mike cassano's league"
task import_mike_cassano: [:environment] do
  NUMBER_OF_SEASONS = 3
  first_season  = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vQsxani6LWbWj1o1LzK8U--98RnBOP5QhIfhSxdkls-8vzUhkPyGlT36prttjrm9dykS2U1680k_QOA/pub?gid=0&single=true&output=csv')
  second_season = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vQsxani6LWbWj1o1LzK8U--98RnBOP5QhIfhSxdkls-8vzUhkPyGlT36prttjrm9dykS2U1680k_QOA/pub?gid=842704448&single=true&output=csv')
  third_season  = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vQsxani6LWbWj1o1LzK8U--98RnBOP5QhIfhSxdkls-8vzUhkPyGlT36prttjrm9dykS2U1680k_QOA/pub?gid=446497304&single=true&output=csv')

  users = URI.parse('https://docs.google.com/spreadsheets/d/e/2PACX-1vQsxani6LWbWj1o1LzK8U--98RnBOP5QhIfhSxdkls-8vzUhkPyGlT36prttjrm9dykS2U1680k_QOA/pub?gid=607317098&single=true&output=csv')

  create_users(Net::HTTP.get(users))

  @csvs ||= [Net::HTTP.get(first_season), Net::HTTP.get(second_season), Net::HTTP.get(third_season)]

  user = User.find_or_create_by(email: 'markmiranda51@gmail.com')
  user.update(password: 'password')

  league = League.find_or_create_by(name: "Mike Cassano's Super Fun League")
  league.update(user_id: user.id)
  puts "Created #{league.name}!"

  seasons_to_create = difference_in_seasons(league.seasons_count)

  unless seasons_to_create.zero?
    seasons_to_create.times do
      league.seasons.create!
    end
  end

  seasons = league.seasons

  seasons.each_with_index do |season, x|
    parse_csv(season, @csvs[x])
  end
end

def create_users(users)
  CSV.parse(users, { row_sep: :auto, headers: true, header_converters: :symbol }) do |row|
    first_name, last_name = row[:person].split

    user = User.find_or_initialize_by(email: row[:email], first_name: first_name, last_name: last_name)
    user.password = SecureRandom.hex
    user.save!
    puts "#{user.full_name} created!"
  end
end

def difference_in_seasons(seasons_count)
  NUMBER_OF_SEASONS - seasons_count
end

def parse_csv(season, csv)
  CSV.parse(csv, { row_sep: :auto, headers: true, header_converters: :symbol }) do |row|
    first_name, last_name = row[:person].split
    date = Date.strptime(row[:date], '%m/%d/%Y')

    user = User.find_by(first_name: first_name, last_name: last_name)
    game = season.games.find_or_create_by(date: date, buy_in: 15, completed: true)
    player = game.players.find_or_create_by(user_id: user.id, finishing_place: row[:place], additional_expense: row[:additional], score: row[:score])

    puts "#{player.user_full_name} finished #{player.finishing_place.ordinalize} in game ##{game.id} on #{game.formatted_date}"
  end
end

