require_relative 'tile'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(9) { Array.new(9) { Tile.new([true, false].sample) } }
  end

  def render
    print ' '
    @grid.each_with_index { |column, index| print ' ' + index.to_s }
    puts
    @grid.each_with_index do |row, index|
      line = index.to_s + ' '
      row.each do |tile|
        if tile.flagged == true
          line += 'F '
        elsif tile.revealed == false
          line += '* '
        else
          if tile.bomb == true
            line += 'B '
          elsif tile.fringe < 1
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
    return false if position.first <= 0
    pos_up = position.first - 1, position.last
    if self[pos_up].bomb == true
      self[position].fringe += 1
      return false
    end

    search_position(pos_up)
    return true
  end

  def look_down(position)
    return false if position.first >= @grid.length - 1
    pos_down = position.first + 1, position.last
    if self[pos_down].bomb == true
      self[position].fringe += 1
      return false
    end

    search_position(pos_down)
    return true
  end

  def look_left(position)
    return false if position.last <= 0
    pos_left = position.first, position.last - 1
    if self[pos_left].bomb == true
      self[position].fringe += 1
      return false
    end

    search_position(pos_left)
    return true
  end

  def look_right(position)
    return false if position.last >= @grid.length - 1
    pos_right = position.first, position.last + 1
    if self[pos_right].bomb == true
      self[position].fringe += 1
      return false
    end

    search_position(pos_right)
    return true
  end

  def search_position(position)
    return if self[position].revealed == true
    self[position].reveal
    return if self[position].bomb == true
    look_up(position)
    look_down(position)
    look_left(position)
    look_right(position)
  end
end
