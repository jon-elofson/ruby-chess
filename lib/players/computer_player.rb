require 'byebug'

class ComputerPlayer

  attr_reader :name, :color

  piece_values = {Pawn => 1, Knight => 3, Bishop => 3, Rook => 5, Queen => 9}

  def initialize(name,color)
    @name = name
    @color = color
  end

  def captures
    captures = {}
    @no_check_moves.each do |move|
      end_pos = move[1]
      if @board.occupied?(end_pos) && @board[*end_pos].color != @color
        capt_val = piece_values[@board[*move[1]].class]
        captures[move] = capt_val
      end
    end
    captures.sort { |a,b| b[1] <=> a[1] }
  end

  def avoid_checks
    avoid_checks = []
    @all_moves.each do |move|
      hyp_board = @board.deep_dup
      if hyp_board.move!(*move)
        avoid_checks << move if hyp_board.in_check?(@color)
      end
    end
    avoid_checks
  end

  def checks
    checks = []
    @all_moves.each do |move|
      hyp_board = @board.deep_dup
      hyp_board.move(*move)
      if hyp_board.in_check?(@board.other_color(@color))
        checks << move
      end
    end
    checks
  end


  def get_out_of_check
    out_of_check_moves = []
    @all_moves.each do |move|
      hyp_board = @board.deep_dup
      hyp_board.move(*move)
      out_of_check_moves << move if !hyp_board.in_check?(@color)
    end
    out_of_check_moves
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

  def find_movable_pieces
    @board.find_pieces(@color).select { |piece| piece.possible_moves.any? }
  end

  def determine_best_move
    if @board.in_check?(@color)
      get_out_of_check.sample
    elsif checks.any?
      checks.sample
    elsif captures.any?
      captures[0]
    else
      @no_check_moves.sample
    end
  end

  def prompt(board)
    @board ||= board
    @pieces = find_movable_pieces
    @all_moves = find_all_moves
    @no_check_moves = @all_moves - avoid_checks
    determine_best_move
  end


end
