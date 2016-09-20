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
      break if valid_start?
    end
    start_pos
  end

  def get_end(start_pos)
    end_pos = []
    until @board[start_pos].valid_moves.include?(end_pos)
      end_pos = @display.move
      return end_pos if end_pos == start_pos
    end
    end_pos
  end

  def valid_start?
    @board.pieces(@color).include?(@board[@display.pos])
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
end
