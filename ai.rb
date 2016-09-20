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
        possible_captures[@board[move]] += [piece] if piece.capture?(move)
      end
    end

    possible_captures
  end

  def pick_capture_move
    return nil if capturable_pieces.empty?

    possible_captures = capturable_pieces.keys
    capture = possible_captures.sort.last
    piece_to_use = capturable_pieces[capture].sort.first

    [piece_to_use, capture]
  end

  def get_start
    sleep(0.3)
    return pick_capture_move[0].position if pick_capture_move
    random_start
  end

  def random_start
    our_pieces = @board.pieces(@color).shuffle
    our_pieces.each do |piece|
      return piece.position unless piece.valid_moves.empty?
    end
  end

  def get_end(start_pos)
    return pick_capture_move[1].position if pick_capture_move
    @board[start_pos].valid_moves.sample
  end

  def valid_start?
    @board.pieces(@color).include?(@board[@display.pos])
  end
end
