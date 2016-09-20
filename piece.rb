require 'singleton'
require 'colorize'
require_relative 'display'

class Piece
  attr_reader :color
  attr_accessor :position, :highlight
  attr_writer :board

  def initialize(position, board, color)
    @board = board
    @position = position
    @color = color
    @highlight = false
  end

  def valid_moves
    moves.reject { |pos| move_into_check?(pos) }
  end

  def move_into_check?(pos)
    new_board = @board.dup
    new_board.move!(@position, pos)
    new_board.in_check?(@color)
  end

  def valid_pos?(pos)
    @board.in_bounds?(pos) && @board[pos].color != @color
  end

  def capture?(pos)
   enemy?(@board[pos])
  end

  def enemy?(piece)
    if @color == "W"
      piece.color == "B"
    else
      piece.color == "W"
    end
  end

  def moves
    []
  end

  def to_s
    str = @color == "W" ? to_char.red : to_char
    case @highlight
    # when :threatened
    #   str.on_red
    when :valid
      str.on_blue
    else
      str
    end
  end

  def inspect
    "#{self.class} #{self.position}"
  end
end

class SlidingPiece < Piece
  def moves_in_dir(dir)
    array = []
    pos = @position

    loop do
      x, y = pos
      pos = [x + dir.first, y + dir.last]
      return array unless valid_pos?(pos)
      return array << pos if capture?(pos)
      array << pos
    end

    array
  end

  def moves
    super

    array = []
    move_dirs.each do |dir|
      array += moves_in_dir(dir)
    end
    array
  end
end

class Bishop < SlidingPiece
  def move_dirs
    [[1, 1], [1, -1], [-1, 1], [-1, -1]]
  end

  def to_char
    "B"
  end
end

class Rook < SlidingPiece
  def move_dirs
    [[0, 1], [0, -1], [1, 0], [-1, 0]]
  end

  def to_char
    "R"
  end
end

class Queen < SlidingPiece
  def move_dirs
    [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end

  def to_char
    "Q"
  end
end

class SteppingPiece < Piece
  def moves
    super
    array = []

    move_dirs.each do |dir|
      x, y = @position
      pos = [x + dir.first, y + dir.last]
      array << pos if valid_pos?(pos)
    end

    array
  end
end

class Knight < SteppingPiece
  def move_dirs
    [[2, 1], [2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2], [-2, 1], [-2, -1]]
  end

  def to_char
    "N"
  end
end

class King < SteppingPiece
  def move_dirs
    [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end

  def to_char
    "K"
  end
end

class Pawn < SteppingPiece
  def initialize(position, board, color)
    @first_move = true
    super
  end

  def move_dirs
    a, b = @color == "W" ? [-1, -2] : [1, 2]

    dirs = []
    x, y = @position

    dirs << [a, 0] if valid_pos?([x + a, y]) && !capture?([x + a, y])

    pos = [x + b, y]
    dirs << [b,0] if @first_move && valid_pos?(pos) && !capture?(pos)

    attack_dirs = [a, -1], [a, 1]
    attack_dirs.pop if y == 7
    attack_dirs.shift if y == 0

    attack_dirs.each do |dir|
      pos = [x + dir.first, y + dir.last]
      dirs << dir if capture?(pos)
    end

    dirs
  end

  def to_char
    "P"
  end
end

class NullPiece < Piece
  def initialize
    @color = ''
  end

  def to_char
    '-'
  end
end
