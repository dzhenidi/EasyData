require_relative 'associatable'

class Guitar < SQLObject
  belongs_to :musician
end

class Musician < SQLObject
  has_many :guitars
  belongs_to :band
end

class Band < SQLObject
  has_many :musicians
end

Guitar.finalize!
Musician.finalize!
Band.finalize!

class MusicInfo

  def initialize
    @guitars = Guitar.all
    @musicians = Musician.all
    @bands = Band.all
  end

  def run
    quit = false
    puts
    puts "Welcome to the Music DB Explorer!"
    until quit
      menu_choice = main_menu
      if menu_choice.upcase == "Q"
        quit = true
      else
        menu_cases(menu_choice)
      end
    end
    puts "Thanks for exploring!"
  end

  def menu_cases(menu_choice)
    if menu_choice == '1'
      table_choice = select_table
      item_id = display_entries(table_choice)
      show_choice(table_choice, item_id)
    elsif menu_choice == '2'
      add_guitar
    elsif menu_choice == '3'
      add_musician
    elsif menu_choice == '4'
      add_band
    elsif menu_choice == '5'
      search
    end
  end

  def select_table
    puts
    puts "Choose a table:"
    puts "1 - Guitars"
    puts "2 - Musicians"
    puts "3 - Bands"
    print "Enter #: "
    choice = gets.chomp
  end

  def display_entries(table)
    table = @guitars if table == '1'
    table = @musicians if table == '2'
    table = @bands if table == '3'
    puts
    num = 1
    table.each do |item|
      puts "#{num} - #{item.name}"
      num += 1
    end
    print "Enter #: "
    choice = gets.chomp
  end

  def main_menu
    puts "Choose an option below: "
    puts "1 - View Data"
    puts "2 - Add Guitar"
    puts "3 - Add Musician"
    puts "4 - Add Band"
    puts "5 - Search"
    puts "Q - QUIT"
    choice = gets.chomp
  end

  def add_guitar
    puts "What is the guitar's name?"
    name = gets.chomp
    puts "Who does this guitar belong to?"
    musician = display_entries('2')
    guitar = Guitar.new({ name: name, musician_id: musician })
    guitar.save
    @guitars = Guitar.all
  end

  def add_musician
    puts "What is the musician's name?"
    name = gets.chomp
    puts "Which band is this musician in?"
    band = display_entries('3')
    musician = Musician.new({ name: name, band_id: band })
    musician.save
    @musicians = Musician.all
  end

  def add_band
    puts "What is the name of the band?"
    name = gets.chomp
    band = Band.new({ name: name })
    band.save
    @bands = Band.all
  end

  def show_guitar(id)
    puts
    guitar = Guitar.find(id)
    puts "Guitar Name: #{guitar.name}"
    puts "Owner: #{guitar.musician.name}"
    puts
    puts "Press enter to return to Main Menu"
    gets.chomp
  end

  def show_musician(id)
    puts
    musician = Musician.find(id)
    puts "Musician Name: #{musician.name}"
    puts "Band Name: #{musician.band.name}"
    puts "Guitars owned:"
    musician.guitars.each do |guitar|
      puts "-#{guitar.name}"
    end
    puts
    puts "Press enter to return to Main Menu"
    gets.chomp
  end

  def show_band(id)
    puts
    band = Band.find(id)
    puts "Band Name: #{band.name}"
    puts "Musicians in the band:"
    band.musicians.each do |musician|
      puts "-#{musician.name}"
    end
    puts
    puts "Press enter to return to Main Menu"
    gets.chomp
  end

  def show_choice(table, id)
    if table == '1'
      show_guitar(id)
    elsif table == '2'
      show_musician(id)
    else
      show_band(id)
    end
  end

  def search
    puts
    menu_return = false
    until menu_return
      menu_return = true
      table = select_table
      print "Enter a name: "
      name = gets.chomp

      results = []
      if table == '1'
        results = Guitar.where({ name: name })
      elsif table == '2'
        results = Musician.where({ name: name })
      elsif table == '3'
        results = Band.where({ name: name })
      else
        menu_return = false
      end

      if results.length < 1
        puts "No results found!"
        puts "Press enter to return to Main Menu"
        gets.chomp
      else
        results.each do |result|
          show_choice(table, result.id)
        end
      end
    end
  end

end

m = MusicInfo.new
m.run
