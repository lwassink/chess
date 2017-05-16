# Chess

This is a fully playable, console chess app. To play, run the `game.rb` file.

The `@player1` and `@player2` instance variables in `Game#initialize` can be set to be either `HumanPlayer` or `AIPlayer`.
It is possible to play vs. the computer, vs. another person, or to watch the computer play itself.
Use the arrow keys to move the cursor and the space bar to select and move a piece.

## Computer Player

The game includes a computer player.
It selects chooses which move to make by assigning a numerical ranking to each possible move based on the value of any piece it would capture, the chance of its being captured, board control considerations, etc.
