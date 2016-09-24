require_relative 'move'

class Player
  attr_reader :color, :last_move

  def initialize(board, display, color)
    @board = board
    @display = display
    @color = color
    @last_move = Move.new
  end

  def possible_moves
    @board.possible_moves(@color)
  end
end
