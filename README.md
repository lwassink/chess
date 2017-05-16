# Chess

This is a fully playable, console chess app. To play chess, run the game.rb file.

You can change @player1 and @player2 in Game#initialize to be either a HumanPlayer or an AIPlayer.
Then you can play vs. the computer, or another person, or watch the computer play itself.
Use the arrows to move the cursor and the space bar to select and move a piece.

## Computer Player

The game includes a computer player.
It selects chooses which move to make by assigning a numerical ranking to each possible move based on the value of any piece it would capture, the chance of its being captured, board control considerations, etc.
