require_relative 'tile'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(9) { Array.new(9) { Tile.new([true, false].sample) } }
  end

  def cursor_location_check(location, cursor_location)
    return false if !cursor_location
    return true if location == cursor_location
  end

  def render(cursor_location)
    system('clear')
    @grid.each_with_index do |row, row_index|
      line = ' '.colorize(background: :light_black)
      row.each_with_index do |tile, column_index|
        if column_index == 0 && cursor_location_check([row_index, column_index], cursor_location)
          line = '['.colorize(:light_red).colorize(background: :light_black)
        end
        if tile.flagged == true
          if cursor_location_check([row_index, column_index + 1], cursor_location)
            line +=
              ('F'.colorize(:cyan) + '['.colorize(:light_red)).colorize(background: :light_black)
          elsif cursor_location_check([row_index, column_index], cursor_location)
            line +=
              ('F'.colorize(:cyan) + ']'.colorize(:light_red)).colorize(background: :light_black)
          else
            line += 'F '.colorize(:cyan).colorize(background: :light_black)
          end
        elsif tile.revealed == false
          if cursor_location_check([row_index, column_index + 1], cursor_location)
            line += ('*' + '['.colorize(:light_red)).colorize(background: :light_black)
          elsif cursor_location_check([row_index, column_index], cursor_location)
            line += ('*' + ']'.colorize(:light_red)).colorize(background: :light_black)
          else
            line += '* '.colorize(background: :light_black)
          end
        elsif tile.bomb == true
          if cursor_location_check([row_index, column_index + 1], cursor_location)
            line += 'B'.colorize(:red) + '['.colorize(:light_red)
          elsif cursor_location_check([row_index, column_index], cursor_location)
            line += 'B'.colorize(:red) + ']'.colorize(:light_red)
          else
            line += 'B '.colorize(:red)
          end
        elsif tile.fringe < 1
          if cursor_location_check([row_index, column_index + 1], cursor_location)
            line += '_'.colorize(:light_black) + '['.colorize(:light_red)
          elsif cursor_location_check([row_index, column_index], cursor_location)
            line += '_'.colorize(:light_black) + ']'.colorize(:light_red)
          else
            line += '_ '.colorize(:light_black)
          end
        else
          if cursor_location_check([row_index, column_index + 1], cursor_location)
            line += "#{tile.fringe.to_s}".colorize(:green) + '['.colorize(:light_red)
          elsif cursor_location_check([row_index, column_index], cursor_location)
            line += "#{tile.fringe.to_s}".colorize(:green) + ']'.colorize(:light_red)
          else
            line += "#{tile.fringe.to_s} ".colorize(:green)
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
    return if self[position].revealed == true || self[position].flagged == true
    self[position].reveal
    return if self[position].bomb == true
    look_up(position)
    look_down(position)
    look_left(position)
    look_right(position)
  end

  def toggle_flag(position)
    self[position].toggle_flag
  end
end
