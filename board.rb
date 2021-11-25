require_relative 'tile'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(9) { Array.new(9) { Tile.new([true, false].sample) } }
  end

  def render
    @grid.each do |row|
      line = ''
      row.each do |tile|
        if tile.flagged == true
          line += 'F '
        elsif tile.revealed == false
          line += '* '
          # TODO: add interior and fringe squares
        end
      end
      puts line
    end
  end
end

board = Board.new
board.render
