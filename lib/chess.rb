require_relative "table"
require_relative "pieces"
require_relative "pieces_modules"
require_relative "modules"

class Game
    include Navigation, Moves

    def initialize
        @table = Table.new
        @turn = 1
    end

    def gameplay
        @table.display_board
        pawn = @table.board[8]
        rook = @table.board[0]
        queen = @table.board[3]
        king = @table.board[4]
        puts "STOP"
    end

end

Game.new.gameplay

#     def gameplay
#         # @board.populate_board(@white, @black)
#         @board.board[27] = Queen.new("Q", 27, "white")
#         @board.board[11] = Rook.new("R", 11, "white")
#         @board.board[20] = Pawn.new("P", 20, "black")
#         @board.display_board
#         piece = @board.board[27]
#         loop do
#             piece = @board.board[select_piece(@board, @turn)]
#             piece.move_piece(@board, select_destination(@board))
#             @board.display_board
#             @turn += 1
#         end
#     end

# end

# Game.new.gameplay