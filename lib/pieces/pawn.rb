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

  def valid_vertical_pawn_move?(pos,test_pos)
    board.on_board?(test_pos) && (board[*test_pos].empty?)
  end

  def valid_diag_pawn_move?(pos,test_pos)
    board.on_board?(test_pos) && board[*test_pos].piece? &&
          (board[*test_pos].color != board[*pos].color)
  end

  def diff_eval(pos,board,diffs)
    result = []
    diffs.each do |dx, dy|
      new_pos = [pos[0] + dx, pos[1] + dy]
      if dy == 0
        result << new_pos if valid_vertical_pawn_move?(pos, new_pos)
      else
        result << new_pos if valid_diag_pawn_move?(pos, new_pos)
      end

    end
    result
  end

  def valid_double_move(pos,board)
    if pos[0] == 6
      new_pos = [pos[0] - 1,pos[1]]
      return true if board[*new_pos].empty?
    elsif pos[0] == 1
      new_pos = [pos[0] + 1,pos[1]]
      return true if board[*new_pos].empty?
    end
    false
  end

  def pawn_moves(pos,board)
    white_diff = [[-1, 0],[-1,-1],[-1,1]] # if valid_double_move(pos,board)
    white_diff << [-2,0] if valid_double_move(pos,board)
    white_diff ||= []

    black_diff = [[1,0],[1,1],[1,-1]] # if valid_double_move(pos,board)
    black_diff << [2,0] if valid_double_move(pos,board)
    black_diff ||= []

    if board[*pos].color == :white
      pawn_moves = []
      pawn_moves += diff_eval(pos,board,white_diff)
    else
      pawn_moves = []
      pawn_moves += diff_eval(pos,board, black_diff)
    end
  end

end
