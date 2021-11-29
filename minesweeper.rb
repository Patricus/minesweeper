require_relative 'board.rb'
require 'io/console'
require 'yaml'
require 'colorize'

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
    @cursor_location = [@board.grid.length / 2, @board.grid.length / 2]
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
    system('clear')
    puts 'Saving Game...'
    File.open('save.yml', 'w') { |file| file.write(@board.to_yaml) }
    puts 'Game saved.'
    puts 'Exiting.'
    exit(true)
  end

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e"
      begin
        input << STDIN.read_nonblock(3)
      rescue StandardError
        nil
      end
      begin
        input << STDIN.read_nonblock(2)
      rescue StandardError
        nil
      end
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def get_input
    input = read_char
    case input
    when ' '
      @board.search_position(@cursor_location)
    when 'f'
      @board.toggle_flag(@cursor_location)
    when "\e"
      save_game
    when "\e[A"
      #UP ARROW
      move_cursor_up
    when "\e[B"
      #DOWN ARROW
      move_cursor_down
    when "\e[D"
      #LEFT ARROW
      move_cursor_left
    when "\e[C"
      #RIGHT ARROW
      move_cursor_right
    else

    end
  end

  def move_cursor_up
    @cursor_location[0] -= 1 if @cursor_location[0] > 0
  end

  def move_cursor_down
    @cursor_location[0] += 1 if @cursor_location[0] < @board.grid.length - 1
  end

  def move_cursor_left
    @cursor_location[1] -= 1 if @cursor_location[1] > 0
  end

  def move_cursor_right
    @cursor_location[1] += 1 if @cursor_location[1] < @board.grid.length - 1
  end

  def run
    while !lost? && !win?
      @board.render(@cursor_location)
      get_input
    end
  end

  def win?
    if @board.grid.flatten.none? { |tile| tile.revealed == false && tile.bomb == false }
      @board.render(@cursor_location)
      puts 'You win!'
      return true
    end
    return false
  end

  def lost?
    if @board.grid.flatten.any? { |tile| tile.revealed == true && tile.bomb == true }
      @board.render(@cursor_location)
      puts 'You lost!'
      return true
    end
    return false
  end
end

mine = Minesweeper.new
mine.run
