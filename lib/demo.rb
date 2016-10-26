require 'byebug'
require_relative 'associatable'

class Bike < SQLObject
  belongs_to :biker
  belongs_to :team
end
  Bike.finalize!
class Biker < SQLObject
  belongs_to :team
  has_many :bikes,
    foreign_key: :owner_id
end
  Biker.finalize!

class Team < SQLObject
  has_many :bikers
  has_many :bikes
end
Team.finalize!


puts Bike.all
