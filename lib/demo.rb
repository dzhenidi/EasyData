require 'byebug'
require_relative 'associatable'

class Bike < SQLObject
  belongs_to :biker,
    foreign_key: :owner_id
  has_one_through :team, :biker, :team

end
class Biker < SQLObject
  belongs_to :team
  has_many :bikes,
    foreign_key: :owner_id
end

class Team < SQLObject
  has_many :bikers
  has_many :bikes
end


Bike.finalize!
Biker.finalize!
Team.finalize!


puts "welcome to this brief EasyData demo"
puts "Currently the database has bikes, bikers, and teams"
puts "I can fetch all entries for a table using ::all. Here are all the bike entries"
puts Bike.all
puts "Bike.all.first.name returns:"
puts Bike.all.first.name
puts "I've used 'belongs_to' and 'has_many' to create associations between models"
puts "This allows us to grab a bike's owner, a bikers' bikes, and a team's bikes and bikers"
puts "We can get the first bike with Bike.where(id: 1)"
puts bike = Bike.where(id: 1)[0]
puts "Its make:"
puts bike.name
puts "Its owner"
puts bike.biker.fname
puts "Its team"
puts bike.team.address
