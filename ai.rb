require_relative 'board'
require_relative 'display'

class AIPlayer
  attr_reader :color

  def initialize(board, display, color)
    @board = board
    @display = display
    @color = color
  end

  def capturable_pieces
    our_pieces = @board.pieces(@color)
    possible_captures = Hash.new([])

    our_pieces.each do |piece|
      piece.valid_moves.each do |move|
        possible_captures[piece] << move if piece.capture?(move)
      end
    end

    possible_captures
  end





  def get_start

  end

  def get_end(start_pos)

  end

  def valid_start?
    @board.pieces(@color).include?(@board[@display.pos])
  end
end
