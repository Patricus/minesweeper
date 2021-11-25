class Tile
  attr_reader :bomb, :flagged

  def initialize(bomb)
    @bomb = bomb
    @flagged = false
  end

  def toggle_flag
    if @flagged == false
      @flagged = true
    else
      @flagged = false
    end
  end
end
