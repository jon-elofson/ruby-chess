require_relative '../modules/slideable'

class Bishop < Piece

  include Slideable

  def initialize(pos,color,board)
    super
  end

  def to_s
    return "♗ " if @color == :white
    return "♝ " if @color == :black
  end

  def possible_moves
    find_diagonals(pos, board)
  end
end
