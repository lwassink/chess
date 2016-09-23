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

  def initialize(board, parent = nil)
    @board = board.dup
    @parent = set_parent(parent) || NulNode
    @children = []
  end

  def score
    @board.score
  end

  def add_child_from_move(start_pos, end_pos)
    child = self.class.new(@board, self)

  end

  def add_child(child)
    child.set_parent(self)
  end

  def set_parent(parent)
    return if @parent == parent
    @parent = parent
    @parent.children << self
  end
end


class NullNode
  def method_missing
  end
end

