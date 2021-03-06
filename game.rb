require_relative 'board'
require_relative 'display'
require_relative  'human_player'
require_relative  'ai'

class Game
  attr_accessor :board

  def initialize(board = nil)
    @board = board || Board.new
    @display = Display.new(@board)
    @player1 = AIPlayer.new(@board, @display, :W)
    @player2 = AIPlayer.new(@board, @display, :B)
    @current_player = @player1
  end

  def play
    until @board.checkmate?(:W) || @board.checkmate?(:B)
      if @current_player.possible_moves.empty?
        declare_stalemate
        return
      end

      play_turn
      system("clear")
      @display.render
    end

    @board.checkmate?(:W) ? declare_victory("Black") : declare_victory("White")
  end

  private

  def declare_victory(str)
    system("clear")
    @display.render
    puts "Congratulations #{str}, you win!"
  end

  def declare_stalemate
    system("clear")
    @board.render
    puts "Game over. It's a stalemate"
  end

  def play_turn
    while true
      start_pos = @current_player.get_start
      highlight_moves(start_pos)
      end_pos = @current_player.get_end(start_pos)
      highlight_moves(start_pos)

      break unless end_pos == :continue
    end

    @board.move(Move.new(start_pos, end_pos))

    switch_players
  end

  def highlight_moves(start_pos)
    @board[start_pos].highlight = @board[start_pos].highlight  ? false : :valid

    @board[start_pos].valid_moves.each do |pos|
      if @board[pos].highlight
        @board[pos].highlight = false
      elsif @board[start_pos].move_into_threat?(pos)
        @board[pos].highlight = :threatened
      else
        @board[pos].highlight = :valid
      end
    end
  end

  def switch_players
    other_player.last_move.each do |pos|
      @board[pos].highlight = false
    end
    @current_player.last_move.each do |pos|
      @board[pos].highlight = :last_move
    end

    @current_player = other_player
  end

  def other_player
    @current_player == @player1 ? @player2 : @player1
  end
end

if __FILE__ == $PROGRAM_NAME
  # b = Board.new(Board.blank_board)
  # r = Rook.new([0,0], b, :W)
  # b[[0,0]] = r
  # r2 = Rook.new([0,1], b, :B)
  # b[[0,1]] = r2
  #
  # g = Game.new(b)
  # g.play

  Game.new.play
end
