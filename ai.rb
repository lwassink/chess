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
    # return pick_capture_move[0].position if pick_capture_move
    # random_start

    @best_move = best_move
    @best_move[:start]
  end

  def get_end(start_pos)
    # if pick_capture_move
    #   end_pos = pick_capture_move[1].position
    # else
    #   end_pos = @board[start_pos].valid_moves.sample
    # end

    end_pos = @best_move[:end]

    @last_move[0] = start_pos
    @last_move[1] = end_pos

    end_pos
  end

  def valid_start?
    @board.pieces(@color).include?(@board[@display.pos])
  end

  def best_move
    possible_moves.sort do |move1, move2|
      rank(move1[:start], move1[:end]) <=> rank(move2[:start], move2[:end])
    end.last
  end

  def rank(start_pos, end_pos)
    piece = @board[start_pos]
    capture_score = @board[end_pos].score

    r = 0
    r += capture_score
    r += 0.9 if capture_score > 0
    r -= piece.score if piece.move_into_threat?(end_pos)
    r += check?(piece, end_pos) ? 0.6 : rand(0.3) 
    r
  end

  def possible_moves
    moves = []
    @board.pieces(@color).each do |piece|
      piece.valid_moves.each do |move|
        moves += [{start: piece.position, end: move}]
      end
    end
    moves
  end

  def random_start
    our_pieces = @board.pieces(@color).shuffle
    our_pieces.each do |piece|
      return piece.position unless piece.valid_moves.empty?
    end
  end

  def check?(piece, end_pos)
    new_board = @board.dup
    new_board.move!(piece.position, end_pos)
    new_board.in_check?(@board.other(@color))
  end
end
