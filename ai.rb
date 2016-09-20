require_relative 'board'
require_relative 'display'
require_relative 'player'

class AIPlayer < Player
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
    sleep(0.8)
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
    if pick_capture_move
      end_pos = pick_capture_move[1].position
    else
      end_pos = @board[start_pos].valid_moves.sample
    end

    @last_move[0] = start_pos
    @last_move[1] = end_pos

    end_pos
  end

  def valid_start?
    @board.pieces(@color).include?(@board[@display.pos])
  end

  def rank(start_pos, end_pos)
    piece = @board[start_pos]
    r = 0
    r += @board[end_pos].score + 0.1
    r -= piece.score if piece.move_into_threat?(end_pos)
    r
  end

  def possible_moves
    moves = {}
    our_pieces.each do |piece|
      moves[piece] = piece.valid_moves
    end
    moves
  end
end
