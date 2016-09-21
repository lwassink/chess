require 'colorize'
require_relative "cursor"
require_relative "board"

class Display


  def initialize(board)
    @board = board
    @cursor = Cursor.new([8, 4], @board)
  end

  def render
    puts '   ' + ('a'..'h').to_a.join('  ')
    8.times do |row|
      row_string = "#{row + 1} "
      8.times do |col|
        current_string = @board[[row, col]].to_s

        unless @board[[row, col]].highlight
          if (row + col).even?
            current_string = current_string.on_white
          end
        end

        current_string = current_string.blink.on_yellow if [row, col] == @cursor.cursor_pos
        row_string += current_string
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

  k = King.new([3,0], b, :W)
  b[[3,0]] = k
  k2 = King.new([7,0], b, :B)
  b[[7,0]] = k2
  r = Rook.new([3,2], b, :B)
  b[[3,2]] = r
  p1 = Bishop.new([3,1], b, :W)
  b[[3,1]] = p1
  # p2 = Pawn.new([5,5], b, :W)
  # b[[5,5]] = p2

  # n = Knight.new([0,0], b, :W)
  # b[[0,0]] = n
  # n1 = Knight.new([1,2], b, :B)
  # b[[1,2]] = n1

  # b1 = Bishop.new([3,3], b, :W)
  # b[[3,3]] = b1
  # n1 = Knight.new([2,2], b, :B)
  # b[[2,2]] = n1
  # n2 = Knight.new([4,4], b, :W)
  # b[[4,4]] = n2
  #
  d = Display.new(b)
  d.render
  print "Valid moves: "
  p p1.valid_moves
  # p p1.moves
  # p p2.moves
end
