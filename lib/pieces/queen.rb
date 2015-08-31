class Queen < Piece

  def initialize(pos,color,board)
    super
  end

  def to_s
    return "♕ " if @color == :white
    return "♛ " if @color == :black
  end

  def possible_moves
    find_diagonals(pos, board) + find_xy_pos(pos,board)
  end


end
