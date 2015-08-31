require_relative 'lib/board'
require_relative 'lib/display'
require_relative 'lib/players/human_player'
require_relative 'lib/players/computer_player'
require_relative 'lib/move_error'
require 'yaml'

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

  def instructions
    system("clear")
    puts "INSTRUCTIONS
    \n You can move your cursor with the arrow keys (▲ ▼ ◀ ▶).
    \n To select a piece, hit ENTER.
    \n Then, select the square you would like to move to and hit SPACE.
    \n Hit q to leave the game.
    \n Hit any key to begin."
    input = gets
    return if input
  end

  def play
    instructions
    until game_over? || @display.save
      find_current_player
      begin
        @display.render
        make_move unless @display.save
      rescue MoveError
        puts "Invalid move!"
        sleep(1)
        retry
      end
      break if game_over? || @display.save
      @last_player = @current_player
    end
    check_game_over
  end

  def check_game_over
    if game_over?
      display_winner
      exit
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
    sleep(3)
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
  puts "Would you like to load a saved game? (y/n)"
  input = gets.chomp
  if input =~ /\A[y]\z/i
    saved_game = YAML::load_file('chess.yml')
    saved_game.play
  else
    puts "Enter your name!"
    player1_name = gets.chomp
    a = HumanPlayer.new(player1_name, :black)
    puts "Would you like to play the computer? (y/n)"
    response = gets.chomp
    if response =~ /\A[y]\z/i
      b = ComputerPlayer.new("KID-A", :white)
    else
      puts "Enter player 2's name!"
      player2_name = gets.chomp
      b = HumanPlayer.new(player2_name,:white)
    end
    c = Chess.new([a,b])
    c.play
  end
end
