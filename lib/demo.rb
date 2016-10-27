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


puts "welcome to EasyData!"
puts "The database has bikes, bikers, and teams."
puts "You can query the tables using ::all, ::find, ::where,"
puts "modify entries using ::create, #update, #destroy,"
puts "or traverse associations"
puts "For example, 'Bike.all.first.biker.fname' returns:"
puts Bike.all.first.biker.fname
