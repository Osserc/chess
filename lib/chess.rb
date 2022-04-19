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

        # @table.board[24] = King.new("Kw", 24, "white", @table.board, @table.move_history)
        # @table.board[39] = King.new("Kb", 39, "black", @table.board, @table.move_history)
        # @table.board[33] = Rook.new("Rw", 33, "white", @table.board, @table.move_history)
        # @table.board[31] = Rook.new("Rb", 31, "black", @table.board, @table.move_history)
        # @table.board[25] = Pawn.new("Pw", 25, "white", @table.board, @table.move_history)
        # @table.board[52] = Pawn.new("Pw", 52, "white", @table.board, @table.move_history)
        # @table.board[54] = Pawn.new("Pw", 54, "white", @table.board, @table.move_history)
        # @table.board[10] = Pawn.new("Pb", 10, "black", @table.board, @table.move_history)
        # @table.board[19] = Pawn.new("Pb", 19, "black", @table.board, @table.move_history)
        # @table.board[37] = Pawn.new("Pb", 37, "black", @table.board, @table.move_history)

        # white_king = @table.board[24]
        # white_pawn_one = @table.board[25]
        # white_pawn_two = @table.board[52]
        # white_pawn_three = @table.board[54]
        # white_rook = @table.board[33]
        # black_pawn_one = @table.board[10]
        # black_pawn_two = @table.board[19]
        # black_pawn_three = @table.board[37]
        # black_rook = @table.board[31]
        # black_king = @table.board[39]
        # white_pawn_one.displaced = 1
        # white_pawn_two.displaced = 1
        # white_pawn_three.displaced = 1
        # black_pawn_one.displaced = 1
        # black_pawn_one.displaced = 1
        # black_pawn_one.displaced = 1

        @table.board[3] = King.new("Kw", 3, "white", @table.board, @table.move_history, @table.turn)
        @table.board[0] = Rook.new("Rw", 0, "white", @table.board, @table.move_history, @table.turn)
        @table.board[7] = Rook.new("Rw", 7, "white", @table.board, @table.move_history, @table.turn)
        rook = @table.board[0]
        rook.displaced = 1

        @table.board[63] = Pawn.new("Pb", 63, "black", @table.board, @table.move_history, @table.turn)

        @table.prepare_turn
        # loop do
        #     @table.prepare_turn
        # end


    end

end

Game.new.gameplay