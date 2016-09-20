require_relative 'board'
require_relative 'display'

class Game
  attr_accessor :board
  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @current_player = "W"
  end

  def play
    until @board.checkmate?("W") || @board.checkmate?("B")
      play_turn
    end

    system("clear")
    @display.render
    print @board.checkmate?("W") ? "Black" : "White"
    puts " won"
  end

  def play_turn
    while true
      start_pos = get_start
      highlight_moves(start_pos)
      end_pos = get_end(start_pos)
      highlight_moves(start_pos)

      break unless end_pos == start_pos
    end

    @board.move(start_pos, end_pos)
    @current_player = @board.other(@current_player)
  end

  def highlight_moves(start_pos)
    @board[start_pos].highlight = @board[start_pos].highlight  ? false : :valid

    @board[start_pos].valid_moves.each do |pos|
      if @board[pos].highlight
        @board[pos].highlight = false
      # elsif @board.threatened?(pos, @current_player)
      #   @board[pos].highlight = :threatened
      else
        @board[pos].highlight = :valid
      end
    end


  end

  def get_start
    start_pos = []
    loop do
      start_pos = @display.move
      break if valid_start?
    end
    start_pos
  end

  def valid_start?
    @board.pieces(@current_player).include?(@board[@display.pos])
  end

  def get_end(start_pos)
    end_pos = []
    until @board[start_pos].valid_moves.include?(end_pos)
      end_pos = @display.move
      return end_pos if end_pos == start_pos
    end
    end_pos
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.play

end
