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
    puts "White score: #{'%.02f' % @board.score(:W).to_s}"
    puts "Black score: #{'%.02f' % @board.score(:B).to_s}"
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

