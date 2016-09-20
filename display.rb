require 'colorize'
require_relative "cursor"
require_relative "board"

class Display


  def initialize(board)
    @board = board
    @cursor = Cursor.new([6,4], @board)
  end

  def render
    puts '  ' + (0..7).to_a.join(' ')
    letters = %w(a b c d e f g h)
    8.times do |row|
      row_string = "#{row} "
      8.times do |col|
        string = @board[[row, col]].to_s
        row_string += [row, col] == @cursor.cursor_pos ? string.on_green.bold : string
        row_string += " "
      end
      puts row_string
    end
  end

  def move
    loop do
      system("clear")
      render

      input = @cursor.get_input
      return input unless input.nil?
    end
  end

  def pos
    @cursor.cursor_pos
  end
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new

  k = King.new([3,0], b, "W")
  b[[3,0]] = k
  k2 = King.new([7,0], b, "B")
  b[[7,0]] = k2
  r = Rook.new([3,2], b, "B")
  b[[3,2]] = r
  p1 = Bishop.new([3,1], b, "W")
  b[[3,1]] = p1
  # p2 = Pawn.new([5,5], b, "W")
  # b[[5,5]] = p2

  # n = Knight.new([0,0], b, "W")
  # b[[0,0]] = n
  # n1 = Knight.new([1,2], b, "B")
  # b[[1,2]] = n1

  # b1 = Bishop.new([3,3], b, "W")
  # b[[3,3]] = b1
  # n1 = Knight.new([2,2], b, "B")
  # b[[2,2]] = n1
  # n2 = Knight.new([4,4], b, "W")
  # b[[4,4]] = n2
  #
  d = Display.new(b)
  d.render
  print "Valid moves: "
  p p1.valid_moves
  # p p1.moves
  # p p2.moves
end
