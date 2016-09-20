class Player
  attr_reader :color, :last_move

  def initialize(board, display, color)
    @board = board
    @display = display
    @color = color
    @last_move = []
  end
end
