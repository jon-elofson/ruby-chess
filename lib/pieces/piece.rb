class Piece

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

  def valid_move?(pos,test_pos)
    board.on_board?(test_pos) && (board[*test_pos].empty? ||
         (board[*test_pos].color != board[*pos].color ))
  end

end
