require_relative '../modules/slideable'

class Queen < Piece

  include Slideable

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

  def valid_move?(pos,test_pos)
    board.on_board?(test_pos) && (board[*test_pos].empty? ||
         (board[*test_pos].color != board[*pos].color ))
  end


end
