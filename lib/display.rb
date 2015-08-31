require 'io/console'
require 'colorize'
require 'byebug'

class Display

  attr_reader :board
  attr_accessor :cpos, :start_pos, :end_pos, :turn, :save


  def initialize(game)
    @game = game
    @board = game.board
    @save = false
  end

  def read_char
  STDIN.echo = false
  STDIN.raw!

  input = STDIN.getch
  if input == "\e" then
    input << STDIN.read_nonblock(3) rescue nil
    input << STDIN.read_nonblock(2) rescue nil
  end

  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def interpret_char
    c = read_char
    case c
    when "\e[A"
      cpos[0] -= 1 unless cpos[0] == 0
    when "\e[B"
      cpos[0] += 1 unless cpos[0] == 7
    when "\e[C"
      cpos[1] += 1 unless cpos[1] == 7
    when "\e[D"
      cpos[1] -= 1 unless cpos[1] == 0
    when "\r"
      self.start_pos = cpos.clone
    when " "
      self.end_pos = cpos.clone
      @turn = false if @start_pos != nil
    when "q"
      save_game_message
    end
  end

  def save_game_message
    puts "Would you like to save the game (y/n)?"
    input = gets.chomp
    if input =~ /\A[y]\z/i
      @save = true
    else
      exit 0
    end
  end

  def render
    @cpos ||= [4,5]
    @start_pos = nil
    @end_pos = nil
    @turn = true
    if @game.current_player.class == HumanPlayer
      while @turn && !@save
        system("clear")
        show_board
        interpret_char
      end
    else
      system("clear")
      show_board
      sleep(2)
      ai_choice = @game.current_player.prompt(@board)
      @start_pos = ai_choice[0]
      @end_pos = ai_choice[1]
    end
  end

  def player_pawn
    if @game.current_player.color == :white
      return "♙"
    else
      return "♟"
    end
  end

  def show_board
    puts "#{@game.current_player.name}'s turn! #{player_pawn}"
    puts '  ' + ('A'..'H').to_a.join(" ")
    8.times do |row|
      print_row = ''
      8.times do |col|
        pos = board[row, col]
        if start_pos == [row,col]
          print_row << pos.to_s.colorize(:background => :black)
        elsif start_pos != nil && board[*start_pos].possible_moves.include?([row,col]) &&
          cpos != [row,col]
          print_row << pos.to_s.colorize(:background => :green)
        elsif cpos == [row,col]
          print_row << pos.to_s.colorize(:background => :yellow)
        elsif start_pos.nil? && board[*cpos].possible_moves.include?([row,col])
          print_row << pos.to_s.colorize(:background => :green)
        elsif (row.even? && col.odd?) || (row.odd? && col.even?)
          print_row << pos.to_s.colorize(:background => :red)
        else
          print_row << pos.to_s.colorize(:background => :blue)
        end
      end
      puts (8 - row).to_s + " " + print_row.colorize(:color => :light_white)
    end
    add_captured_pieces
    nil
  end
end

def add_captured_pieces
  print "White Captured:"
  puts @board.white_captured.join
  print "Black Captured:"
  puts @board.black_captured.join
end
