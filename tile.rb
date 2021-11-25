class Tile
  attr_reader :bomb, :flagged, :revealed

  def initialize(bomb)
    @bomb = bomb
    @flagged = false
    @revealed = false
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
