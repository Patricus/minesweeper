require_relative 'board.rb'

class Minesweeper
  def initialize
    @turns = 0
    @board = Board.new
  end

  def guess_valid?(guess)
    if guess.length != 3
      puts 'Must be 3 characters! (ex. "4,2")'
      return false
    end
    guess.each_char.with_index do |char, index|
      if index == 1
        if char != ','
          puts 'Did you forget a comma?'
          return false
        end
      else
        if !%w[1 2 3 4 5 6 7 8 9 0].include?(char)
          puts 'Enter valid numbers.'
          return false
        end
      end
    end
    guess = guess.split(',')
    if !(0...@board.grid.length - 1).include?(Integer(guess.first)) ||
         !(0...@board.grid.length - 1).include?(Integer(guess.last))
      puts 'Position is not on the board.'
      return false
    end
    return true
  end

  def get_guess
    puts 'Enter a position to reveal: (ex. "1,2")'
    guess = ''
    guess = gets.chomp
    guess = gets.chomp while !guess_valid?(guess)
    guess.split(',').map { |x| Integer(x) }
  end

  def run
    @board.render
    @board.search_position(get_guess)
  end
end

mine = Minesweeper.new
mine.run
