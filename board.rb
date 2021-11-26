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
        else
          if tile.fringe < 1
            line += '_ '
          else
            line += "#{tile.fringe.to_s} "
          end
        end
      end
      puts line
    end
  end

  def [](position)
    @grid[position.first][position.last]
  end

  def look_up(position)
    pos_up = position.first - 1, position.last
    return self[position].fringe += 1 if self[pos_up].bomb == true
    self[pos_up].reveal
    look_up(pos_up)
  end

  def look_down(position)
    pos_down = position.first + 1, position.last
    return self[position].fringe += 1 if self[pos_down].bomb == true
    self[pos_down].reveal
    look_down(pos_down)
  end

  def look_left(position)
    pos_left = position.first, position.last - 1
    return self[position].fringe += 1 if self[pos_left].bomb == true
    self[pos_left].reveal
    look_left(pos_left)
  end

  def look_right(position)
    pos_right = position.first, position.last + 1
    return self[position].fringe += 1 if self[pos_right].bomb == true
    self[pos_right].reveal
    look_right(pos_right)
  end

  def search_position(position)
    self[position].reveal
    look_up(position)
    look_down(position)
    look_left(position)
    look_right(position)
  end
end

board = Board.new
board.render
board.search_position([3, 3])
board.render
