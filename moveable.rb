require 'byebug'

module Moveable

  def valid_move?(pos,test_pos)
    board.on_board?(test_pos) && (board[*test_pos].empty? ||
         (board[*test_pos].color != board[*pos].color ))
  end

  def valid_vertical_pawn_move?(pos,test_pos)
    board.on_board?(test_pos) && (board[*test_pos].empty?)
  end

  def valid_diag_pawn_move?(pos,test_pos)
    board.on_board?(test_pos) && board[*test_pos].piece? &&
          (board[*test_pos].color != board[*pos].color)
  end

  def find_diagonals(pos, board)
    diffs = [[1,1],[-1,-1],[1,-1],[-1,1]]
    diagonals = diff_eval_brq(pos,board,diffs)
  end

  def find_xy_pos(pos, board)
    diffs = [[0,1], [0,-1], [1,0], [-1,0]]
    xypos = diff_eval_brq(pos,board,diffs)
  end

  def king_moves(pos,board)
    diffs = [1,1,0,0,-1,-1].permutation(2).to_a.uniq - [[0,0]]
    king_moves = diff_eval_kk(pos,board,diffs)
  end

  def knight_moves(pos, board)
    diffs = [2,1,-2,-1].permutation(2).to_a.select { |x,y| x.abs != y.abs }
    knight_moves = diff_eval_kk(pos,board,diffs)
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
      pawn_moves += diff_eval_p(pos,board,white_diff)
    else
      pawn_moves = []
      pawn_moves += diff_eval_p(pos,board, black_diff)
    end
  end

  # def valid_diags(diags)
  #   diags.select { |d| board[*d].piece? && board[*d].color != board[*pos].color }
  # end


  def diff_eval_kk(pos,board,diffs)
    result = []
    diffs.each do |dx, dy|
      new_pos = [pos[0] + dx, pos[1] + dy]
      result << new_pos if valid_move?(pos, new_pos)
    end
    result
  end

  def diff_eval_p(pos,board,diffs)
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

  def diff_eval_brq(pos,board,diffs)
    result = []
    diffs.each do |dx,dy|
      new_pos = [pos[0] + dx, pos[1] + dy]
      i = 1
      while valid_move?(pos, new_pos)
        result << new_pos
        break if board[*new_pos].piece?
        i += 1
        new_pos = [pos[0] + (dx * i), pos[1] + (dy * i)]
      end
    end
    result
  end

end
