require_relative "table"
require_relative "pieces"
require_relative "pieces_modules"
require_relative "modules"

class Game

    include Navigation, Moves

    def initialize
        @table = Table.new
    end

    def gameplay
        @table.board[11] = Rook.new("R", 11, "white", @table.board, @table.move_history)
        @table.board[25] = Bishop.new("B", 25, "black", @table.board, @table.move_history)
        @table.board[30] = Queen.new("Q", 30, "black", @table.board, @table.move_history)
        @table.board[10] = Pawn.new("P", 10, "white", @table.board, @table.move_history)
        @table.board[7] = King.new("Kw", 7, "white", @table.board, @table.move_history)
        @table.board[13] = King.new("Kb", 13, "black", @table.board, @table.move_history)
        rook = @table.board[11]
        bishop = @table.board[25]
        queen = @table.board[30]
        pawn = @table.board[10]
        @table.collect_pieces
        @table.display_board
        white_king = @table.find_white_king
        black_king = @table.find_black_king
        @table.regenerate_moveset_white
        @table.regenerate_moveset_black
        white = @table.black_in_check?
        black = @table.white_in_check?
        puts "STOP"
    end

end

# Make the move in question
# Test if the player who made the move is in check
# revert the move

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