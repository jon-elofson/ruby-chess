class Pawn < Piece

  def initialize(pos,color,board)
    super
  end

  def to_s
    return "♙ " if @color == :white
    return "♟ " if @color == :black
  end

  def possible_moves
    pawn_moves(pos,board)
  end

end
