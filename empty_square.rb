class EmptySquare

  def piece?
    false
  end

  def empty?
    true
  end

  def moves
    []
  end

  def to_s
    "  "
  end

  def color
    nil
  end

  def possible_moves
    []
  end

  def dup(board_copy)
    EmptySquare.new
  end


end
