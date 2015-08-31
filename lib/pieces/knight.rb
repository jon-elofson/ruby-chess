require_relative '../modules/steppable'

class Knight < Piece

  include Steppable

  def initialize(pos,color,board)
    super
  end

  def to_s
    return "♘ " if @color == :white
    return "♞ " if @color == :black
  end

  def possible_moves
    knight_moves(pos,board)
  end

  def knight_moves(pos, board)
    diffs = [2,1,-2,-1].permutation(2).to_a.select { |x,y| x.abs != y.abs }
    knight_moves = diff_eval(pos,board,diffs)
  end


end
