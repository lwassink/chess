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

  def move(start_pos, end_pos)
    piece = self[start_pos]
    raise "Cannot move into check" if piece.move_into_check?(end_pos)
    if piece.is_a?(Pawn)
      piece.first_move = false
      if end_pos[0] == 0 || end_pos[0] == 7
        self[start_pos] = Queen.new(start_pos, self, piece.color)
      end
    end
    move!(start_pos, end_pos)
  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]
    raise "Invalid move: no piece at #{start_pos}" if piece.is_a?(NullPiece)

    self[end_pos] = piece
    piece.position = end_pos
    self[start_pos] = NullPiece.new
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
    king_pos = find_king(color)
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

  end

  private

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
