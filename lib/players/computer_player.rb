class ComputerPlayer

  attr_reader :name, :color

  def initialize(name,color)
    @name = name
    @color = color
  end

  def captures
    captures = []
    @no_check_moves.each do |move|
      start_pos,end_pos = move
      if @board.occupied?(end_pos) && @board[*end_pos].color != @color
        captures << [start_pos,end_pos]
      end
    end
    captures
  end

  def avoid_checks
    avoid_checks = []
    @all_moves.each do |move|
      start_pos, end_pos = move
      hyp_board = @board.deep_dup
      hyp_board.move()
      checks << [pieve.pos,move] if hyp_board.in_check?(@color)
    end
    avoid_checks
  end

  def checks
    checks = []
    @all_moves.each do |move|
      start_pos, end_pos = move
      hyp_board = @board.deep_dup
      hyp_board.move(piece.pos,move)
      if hyp_board.in_check?(board.other_color(@color))
        checks << [pieve.pos,move]
      end
    end
    checks
  end

  def find_all_moves
    all_moves = []
    @pieces.each do |piece|
      piece.possible_moves.each do |move|
        all_moves << [piece.pos,move]
      end
    end
    all_moves
  end

  def prompt(board)
    @board = board
    @pieces = board.find_pieces(@color).select { |piece| piece.possible_moves.length > 0}
    @all_moves = find_all_moves
    @no_check_moves = @all_moves - avoid_checks
    if checks.any?
      checks.sample
    elsif captures.any?
      captures.sample
    else
      @no_check_moves.sample
    end
  end


end
