#!/usr/bin/ruby
#
# Copyright (C) 2016 Luke Wassink <lwassink@gmail.com>
#
# Distributed under terms of the MIT license.
#


require_relative 'board'

class ChessNode
  attr_reader :board
  attr_reader :parent
  attr_reader :children
  attr_reader :move
  attr_reader :color

  # each node stems from an original choice of move, which we track
  def initialize(board, move, color, parent = nil)
    @board = board.dup
    @parent = parent || NullNode
    @children = []
    @move = move
    @color = color # color's move created this node
  end

  def score(color = @color)
    @board.score(color)
  end

  def generate_move_children
    @board.possible_moves(other_color).each do |move|
      add_child_from_move(move)
    end
  end

  def add_child_from_move(move)
    child = self.class.new(@board, @move, other_color, self)
    child.board.move(move)
    add_child(child)
  end

  def add_child(child)
    child.set_parent(self)
  end

  def parent=(node)
    set_parent(node)
  end

  def set_parent(parent)
    @parent.children.delete(self)
    @parent = parent
    @parent.children << self
  end

  def other_color
    @board.other(@color)
  end
end


class NullNode
  def method_missing
  end

  def children
    []
  end
end

