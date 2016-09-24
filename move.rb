#!/usr/bin/ruby
#
# Copyright (C) 2016 Luke Wassink <lwassink@gmail.com>
#
# Distributed under terms of the MIT license.
#


Move = Struct.new(:start, :end) do
  def each
    return if self.start.nil? || self.end.nil?

    yield self.start
    yield self.end
  end

  def to_s
    "Start: #{self.start}, end: #{self.end}"
  end

  def inspect
    to_s
  end
end
