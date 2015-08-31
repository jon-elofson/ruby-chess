require_relative 'pieces/empty_square'
require_relative 'pieces/piece'
require_relative 'pieces/pawn'
require_relative 'pieces/bishop'
require_relative 'pieces/knight'
require_relative 'pieces/rook'
require_relative 'pieces/queen'
require_relative 'pieces/king'
require_relative 'display'
require_relative 'move_error'
require 'colorize'

class Board

  attr_reader :white_captured, :black_captured

  def initialize(flag=true)

    @grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
    @white_captured = []
    @black_captured = []
    populate_board if flag
  end

  def [](row,col)
    @grid[row][col]
  end

  def []=(row,col,value)
    @grid[row][col] = value
  end

  def on_board?(pos)
    pos.all? { |i| i.between?(0, 7) }
  end

    def populate_board
      populate_back_row(:black)
      populate_back_row(:white)
      populate_pawns(:black)
      populate_pawns(:white)
    end

    def populate_back_row(color)
      color == :black ? row = 0 : row = 7
      back_row_classes = [Rook, Knight, Bishop,Queen,King,Bishop,Knight,Rook]
      back_row_classes.each_with_index do |piece,col|
        self[row,col] = piece.new([row,col],color,self)
      end
    end

    def populate_pawns(color)
      color == :black ? row = 1 : row = 6
      8.times do |col|
        self[row, col] = Pawn.new([row, col],color,self)
      end
    end

    def occupied?(pos)
      self[*pos].piece?
    end

    def find_pieces(color)
      pieces = []
      8.times do |row|
        8.times do |col|
          pieces << self[row,col] if self[row,col].color == color
        end
      end
      pieces
    end

    def other_color(color)
      return :black if color == :white
      return :white if color == :black
    end

    def in_check?(color)
      king = find_pieces(color).select { |piece| piece.class == King }.first
      opponent_pieces = find_pieces(other_color(color))
      opponent_pieces.each do |piece|
        return true if piece.possible_moves.include?(king.pos)
      end
      false
    end

    def checkmate?(color)
      return false unless in_check?(color)
      pieces = find_pieces(color)
      pieces.each do |piece|
        piece.possible_moves.each do |move|
          return false if valid_move?(piece.pos, move)
        end
      end
      true
    end

    def move(start_pos,end_pos)
      if valid_move?(start_pos,end_pos)
        move!(start_pos, end_pos)
      else
        puts "Can't make that move!"
        raise MoveError
      end
    end

    def valid_move?(start_pos,end_pos)
      return false if self[*start_pos].possible_moves.include?(end_pos) == false
      board_copy = self.deep_dup
      board_copy.move!(start_pos,end_pos)
      return false if board_copy.in_check?(self[*start_pos].color)
      true
    end

    def move!(start_pos,end_pos)
      if self[*start_pos].possible_moves.include?(end_pos)
        if occupied?(end_pos)
          capture(self[*end_pos])
        end
        self[*end_pos] = self[*start_pos]
        self[*start_pos] = EmptySquare.new
        self[*end_pos].pos = end_pos
      end
    end

    def capture(piece)
      if piece.color == :black
        @black_captured << piece
      else
        @white_captured << piece
      end
    end

    def deep_dup
      board_copy = Board.new(false)
      8.times do |row|
        8.times do |col|
          board_copy[row,col] = self[row,col].dup(board_copy)
        end
      end
      board_copy
    end
end
