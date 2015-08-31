require_relative 'board'
require_relative 'display'
require_relative 'player'
require_relative 'move_error'

class Chess

  attr_reader :board, :current_player

  def initialize(players)
    @players = arrange_players_in_order(players)
    @board = Board.new
    @display = Display.new(self)
    @last_player = nil
  end

  def arrange_players_in_order(players)
    arranged_players = []
    if players[0].color == :black
      arranged_players = [players[1], players[0]]
    end
  end

  def play
    #instructions
    until game_over? || @display.save
      find_current_player
      begin
        @current_player.prompt
        @display.render
        make_move unless @display.save
      rescue MoveError
        puts "Invalid move!"
        retry
      end
      break if game_over? || @display.save
      @last_player = @current_player
    end

    if game_over?
      display_winner
      @display.render
    else
      save_game
    end
  end

  def find_current_player
    if @last_player.nil?
      @current_player = [@players.first]
    else
      @current_player = @players - [@last_player]
    end
    @current_player = @current_player.first
  end

  def save_game
    @display.save = false
    File.open("chess.yml", "w") { |f| f.puts self.to_yaml }
    puts "Your game is saved as 'Chess.yml'"
  end

  def display_winner
    puts "Game over. White won!" if @board.checkmate?(:black)
    puts "Game over. Black won!" if @board.checkmate?(:white)
  end

  def game_over?
    @board.checkmate?(:white) || @board.checkmate?(:black)
  end

  def start_pos
    @display.start_pos
  end

  def end_pos
    @display.end_pos
  end

  def make_move
    raise MoveError if start_pos == end_pos
    raise MoveError if @board[*start_pos].empty?
    raise MoveError if  @board[*start_pos].color != @current_player.color
    unless start_pos.nil? && end_pos.nil?
      @board.move(start_pos,end_pos)
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  puts "Would you like to load a saved game?"
  input = gets.chomp
  if input =~ /\A[y]\z/i
    saved_game = YAML::load_file('chess.yml')
    saved_game.play
  else
    a = Player.new("Jon", :black)
    b = Player.new("Varun", :white)
    c = Chess.new([a, b])
    c.play
  end
end
