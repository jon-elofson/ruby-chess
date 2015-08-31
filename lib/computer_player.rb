class ComputerPlayer

  attr_reader :name, :color

  def initialize(name,color)
    @name = name
    @color = color
  end

  def find_captures(board)
    captures = []
    @pieces.each do |piece|
      piece.possible_moves.each do |move|
        if board.occupied?(move) && board[*move].color != @color
          captures << [piece.pos,move]
        end
      end
    end
    captures
  end

  def prompt(board)
    @pieces = board.find_pieces(@color).select { |piece| piece.possible_moves.length > 0}
    captures = find_captures(board)
    return captures.sample if captures.length > 0
    piece = @pieces.sample
    start_pos = piece.pos
    end_pos = piece.possible_moves.sample
    return [start_pos,end_pos]
  end

end
