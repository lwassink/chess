require_relative "piece"

class Board
  def initialize(board = nil)
    @board = board || create_board
  end

  def self.blank_board
    board = []
    8.times do
      board << Array.new(8) { NullPiece.new }
    end
    board
  end

  def move(move)
    piece = self[move.start]
    raise "Cannot move into check" if piece.move_into_check?(move.end)

    if piece.is_a?(Pawn)
      piece.first_move = false
      if move.end[0] == 0 || move.end[0] == 7
        self[move.start] = Queen.new(move.start, self, piece.color)
      end
    end

    move!(move)
  end

  def move!(move)
    piece = self[move.start]
    raise ArgumentError, "Invalid move: no piece at #{move.start}" if piece.is_a?(NullPiece)

    self[move.end] = piece
    piece.position = move.end
    self[move.start] = NullPiece.new
  end

  def in_check?(color)
    king_pos = find_king(color)
    pieces = pieces(other(color))

    pieces.any? { |piece| piece.moves.include?(king_pos) }
  end

  def in_threat?(pos, color)
    pieces = pieces(other(color))
    pieces.any? { |piece| piece.moves.include?(pos) }
  end

  def checkmate?(color)
    return false unless in_check?(color)

    pieces = pieces(other(color))
    pieces(color).all? { |piece| piece.valid_moves.empty? }
  end

  def other(color)
    color == :W ? :B : :W
  end

  def pieces(color)
    @board.flatten.select { |el| el.color == color }
  end

  def in_bounds?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end

  def rows
    @board
  end

  def [](pos)
    x, y = pos
    @board[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @board[x][y] = value
  end

  def dup
    new_board = Array.new(8) { null_row }
    board = Board.new(new_board)

    @board.each_with_index do |row, idx|
      row.each do |piece|
        unless piece.is_a?(NullPiece)
          new_piece = piece.dup
          new_piece.board = board
          board[new_piece.position] = new_piece
        end
      end
    end


    board
  end

  def inspect
    "Board"
  end

  # calculates the board score from the point of view of color
  def score(color)
    mc = move_count(other(color))
    s = 0
    s += 2 * norm(move_count(color) / mc) unless mc == 0
    s += 2 if mc == 0
    s += 10 * norm(total_piece_score(color) / total_piece_score(other(color)))
    s += 0.5 if in_check?(other(color))
    s -= 0.5 if in_check?(color)
    s / 11
  end

  def possible_moves(color)
    moves = []
    pieces(color).each do |piece|
      piece.valid_moves.each do |pos|
        moves += [Move.new(piece.position, pos)]
      end
    end
    moves
  end

  private

  def norm(num)
    1.0 / (1 + 2**num)
  end

  def move_count(color)
    possible_moves(color).length
  end

  def total_piece_score(color)
    pieces(color).reduce(0) { |sum, piece| sum + piece.score }
  end

  def create_board
    board = []
    board << back_row(:B)
    board << front_row(:B)
    4.times do
       board << null_row
    end
    board << front_row(:W)
    board << back_row(:W)

    board
  end

  def front_row(color)
    color == :W ? y = 6 : y = 1
    Array.new(8) { |i| Pawn.new([y, i], self, color)}
  end

  def back_row(color)
    y = color == :W ? 7 : 0
    [Rook.new([y,0], self, color),
      Knight.new([y,1], self, color),
      Bishop.new([y,2], self, color),
      Queen.new([y,3], self, color),
      King.new([y,4], self, color),
      Bishop.new([y,5], self, color),
      Knight.new([y,6], self, color),
      Rook.new([y,7], self, color)]
  end

  def null_row
    Array.new(8) { NullPiece.new }
  end

  def find_king(color)
    king = @board.flatten.find { |el| el.is_a?(King) && el.color == color }
    king.position
  end
end
