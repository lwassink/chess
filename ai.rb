require_relative 'board'
require_relative 'display'
require_relative 'player'

class AIPlayer < Player
  def get_start
    sleep(0.8)

    @best_move = best_move
    @best_move[:start]
  end

  def get_end(start_pos)
    end_pos = @best_move[:end]

    @last_move[0] = start_pos
    @last_move[1] = end_pos

    end_pos
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
    r += 0.8 if check?(piece, end_pos)
    r += Random.rand(0.3)
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

  def check?(piece, end_pos)
    new_board = @board.dup
    new_board.move!(piece.position, end_pos)
    new_board.in_check?(@board.other(@color))
  end
end
