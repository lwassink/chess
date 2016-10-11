require_relative 'board'
require_relative 'display'
require_relative 'player'
require_relative 'chess_node'

class AIPlayer < Player
  MAX_NODE_COUNT = 100

  def get_start
    sleep(0.8)
    # puts "==================================================="
    move = best_move
    # puts "Move: #{move}"
    # puts "==================================================="

    @last_move = move
    @last_move.start
  end

  def get_end(start_pos)
    @last_move.end
  end

  # private

  def best_move
    possible_moves.sort do |move1, move2|
      rank(move1) <=> rank(move2)
    end.last
  end

  def rank(move)
    piece = @board[move.start]
    capture_score = @board[move.end].score

    r = 0
    r += capture_score # it's good to capture good pieces
    r += 0.9 if capture_score > 0 # in fact, you get a little bonus for capturing something
    # this is so that pieces will be agressive and trade like for like
    r -= piece.score if piece.move_into_threat?(move.end) # it's bad to put yourself in a position where you could die
    r += 0.8 if check?(piece, move.end) # it's good to put the enemy in check
    r += Random.rand(0.3) # if multiple moves are otherwise equal, let's not do the same
    # thing every time
    r
  end

  def check?(piece, end_pos)
    new_board = @board.dup
    new_board.move!(Move.new(piece.position, end_pos))
    new_board.in_check?(@board.other(@color))
  end

  #========================================

  def best_move_by_score
    setup_move_data
    puts "setup complete..."
    explore_nodes
    puts "exploration complete..."
    m = @board.possible_moves(@color).max_by do |move|
      print "move: #{move}, score: "
      p move_score(move)
    end
    puts "selection complete..."
    m
  end

  def setup_move_data
    @node_count = {W: 0, B: 0}
    @node_queue = []
    @finished_leafs = []
    @total_node_score = {W: 0, B:0}

    @board.possible_moves(@color).each do |move|
      node = ChessNode.new(@board, move, @color)
      node.board.move(move)
      @node_queue.push(node)
    end
  end

  def explore_nodes
    MAX_NODE_COUNT.times do |i|
      puts "#{i}th node being processed"
      proccess_node(@node_queue.shift)
    end
  end

  def proccess_node(node)
    @node_count[node.color] += 1
    @total_node_score[node.color] += node.score
    node.generate_move_children

    if node.score(node.other_color) > 0.8 * ave_node_score(node.other_color)
      @node_queue += node.children
    else
      @finished_leafs += node.children
    end
  end

  def ave_node_score(color)
    if @node_count[color] == 0
      0
    else
      @total_node_score[color] / @node_count[color]
    end
  end

  def leafs(move)
    (@node_queue + @finished_leafs).select { |leaf| leaf.move == move }
  end

  def move_score(move)
    leafs = leafs(move)
    count = leafs.count
    leafs.reduce(0) { |sum, leaf| sum + leaf.score(@color) } / count
  end
end
