require_relative '../modules/steppable'

class King < Piece

  include Steppable

  def initialize(pos,color,board)
    super
  end

  def to_s
    return "♔ " if @color == :white
    return "♚ " if @color == :black
  end

  def possible_moves
    king_moves(pos,board)
  end

  def king_moves(pos,board)
    diffs = [1,1,0,0,-1,-1].permutation(2).to_a.uniq - [[0,0]]
    king_moves = diff_eval(pos,board,diffs)
  end


end
