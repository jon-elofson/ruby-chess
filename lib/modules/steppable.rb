module Steppable

  def diff_eval(pos,board,diffs)
    result = []
    diffs.each do |dx, dy|
      new_pos = [pos[0] + dx, pos[1] + dy]
      result << new_pos if valid_move?(pos, new_pos)
    end
    result
  end

end
