module Slideable

  def find_xy_pos(pos, board)
    diffs = [[0,1], [0,-1], [1,0], [-1,0]]
    xypos = diff_eval(pos,board,diffs)
  end

  def find_diagonals(pos, board)
    diffs = [[1,1],[-1,-1],[1,-1],[-1,1]]
    diagonals = diff_eval(pos,board,diffs)
  end

  def diff_eval(pos,board,diffs)
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
