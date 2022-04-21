# chess

As part of the Odin Project, the final assignment of the Ruby course is building a fully functional game of chess to be played through the command line.

The strategy I employed is a heavily piece-centric one: each piece dinamically generates its own set of moves by looking at the board and looking at its surroundings.

Check functionality is fully integrated into move generation: the game will not allow the player to make a move that would put the king in check.

This project changed a lot from how it started. The biggest change is moving the move history and the board to two modules, making them variables, so that the pieces no longer carry around a copy of both.

To accomplish this I had to familiarize myself with module variables, which was an interesting experience. Previously struggled to pass a variable down a chain and keeping track of it to see where it was needed, and I resolved to give it to every piece. Putting it in a module solved a lot og logistical problems and made debugging a lot easier.

While this made my code significantly cleaner, there are still many optimizations to be made, like cleaning up the Table class and the check module, but I decided to move forward with TOP instead of focusing too much on refactoring.

All in all, it was an extremely fun and engaging project: coming up with ways to make all the pieces able to understand where to go was very stimulating and pushed me to my limits.

Live preview: 