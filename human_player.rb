require_relative 'board'
require_relative 'display'

class HumanPlayer
  attr_reader :color

  def initialize(board, display, color)
    @board = board
    @display = display
    @color = color
  end

  def get_start
    start_pos = []
    loop do
      start_pos = @display.move
      break if valid_start?(start_pos)
    end
    start_pos
  end

  def get_end(start_pos)
    end_pos = []
    until @board[start_pos].valid_moves.include?(end_pos)
      end_pos = @display.move
      return :continue if end_pos == start_pos
    end
    end_pos
  end

  def valid_start?(start_pos)
    @board.pieces(@color).include?(@board[start_pos])
    true
  end
end
