# Chess

A Ruby implementation with a command line interface.

## How to Play

###Getting Set Up
You will need Ruby installed on your system to play this game. Download the code and using the command line, navigate to the main directory. Next, run the 'chess.rb' file with the command 'ruby chess.rb'. This will prompt you to load a saved game or choose the type of game you'd like to play.

###Playing the Game
You can move your cursor with the arrow keys (▲ ▼ ◀ ▶). When you hover over a piece, all of the squares where that piece can move will be highlighted in green To select a piece to move, hit ENTER. Then, select the square you would like to move to and hit SPACE.

![chess-screenshot](images/screenshot.png)

## Technologies

The game is written with Ruby. It requires two gems - colorize and io-console.

## Implementation Details

### [Game Saving][game-saving]
Used YAML to allow the saving of game states. Users now have the option to load previous games on initialize.



### [Modules][slideable]
Used modules (slideable, steppable) and inheritance to keep the code as DRY as possible.


### [AI][ai]
AI identifies puts other player into check/checkmate if possible and avoids putting itself into check. It will capture the highest value piece that it can.

[slideable]:https://github.com/jon-elofson/ruby-chess/blob/master/lib/modules/slideable.rb#L1
[ai]:https://github.com/jon-elofson/ruby-chess/blob/master/lib/players/computer_player.rb#L85
[game-saving]:https://github.com/jon-elofson/ruby-chess/blob/master/chess.rb#L76


## TODO
* working on my knight moves
* implement poly tree node for AI
