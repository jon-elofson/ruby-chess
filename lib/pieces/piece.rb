require_relative '../modules/moveable'

class Piece
  include Moveable

  attr_reader :color, :board
  attr_accessor :pos

  def initialize(pos,color,board)
    @pos = pos
    @board = board
    @color = color
  end

  def empty?
    false
  end

  def piece?
    true
  end

  def dup(board_copy)
    self.class.new(pos,color,board_copy)
  end

end
