require_relative 'board.rb'
require 'yaml'

class Minesweeper
  def load_board
    @board = YAML.load(File.read('save.yml'))
    File.delete('save.yml')
  end

  def initialize
    if File.exists?('save.yml')
      load_board
    else
      @board = Board.new
    end
  end

  def guess_valid?(guess)
    if guess.length != 3 && (guess.length == 6 && guess[-3..-1] != ' -f')
      puts 'Must be 3 characters or have a "-f" tag! (ex. "4,2 -f")'
      return false
    end
    guess[0...3].each_char.with_index do |char, index|
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
    flag = guess[-1] == 'f'
    guess = guess[0..3].split(',')
    if !(0...@board.grid.length).include?(Integer(guess.first)) ||
         !(0...@board.grid.length).include?(Integer(guess.last))
      puts 'Position is not on the board.'
      return false
    elsif !flag && @board[guess.map(&:to_i)].flagged == true
      puts 'Can\'t guess a fagged position!'
      return false
    elsif @board[guess.map(&:to_i)].revealed == true
      puts 'Can\'t guess a revealed position!'
      return false
    end
    return true
  end

  def save_game
    File.open('save.yml', 'w') { |file| file.write(@board.to_yaml) }
    puts 'Game saved.'
  end

  def get_guess
    puts 'Enter a position to reveal: (ex. "1,2")'
    guess = ''
    guess = gets.chomp
    if guess == 'save'
      save_game
      guess = gets.chomp
    end
    guess = gets.chomp while !guess_valid?(guess)
    if guess[-1] == 'f'
      return guess[0, 3].split(',').map { |x| Integer(x) } + [guess[-1]]
    else
      return guess[0, 3].split(',').map { |x| Integer(x) }
    end
  end

  def run
    while !lost? && !win?
      @board.render
      guess = get_guess
      guess[-1] == 'f' ? @board.toggle_flag(guess[0...2]) : @board.search_position(guess)
    end
  end

  def win?
    if @board.grid.flatten.none? { |tile| tile.revealed == false && tile.bomb == false }
      @board.render
      puts 'You win!'
      return true
    end
    return false
  end

  def lost?
    if @board.grid.flatten.any? { |tile| tile.revealed == true && tile.bomb == true }
      @board.render
      puts 'You lost!'
      return true
    end
    return false
  end
end

mine = Minesweeper.new
mine.run
