class Tile
  attr_reader :bomb, :flagged, :revealed
  attr_accessor :fringe

  def initialize(bomb)
    @bomb = bomb
    @flagged = false
    @revealed = false
    @fringe = 0
  end

  def toggle_flag
    if @flagged == false
      @flagged = true
    else
      @flagged = false
    end
  end

  def reveal
    @revealed = true
  end
end
