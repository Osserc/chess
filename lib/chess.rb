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

        @table.board[19] = King.new("Kw", 19, "white", @table.board, @table.move_history)
        @table.board[63] = King.new("Kb", 63, "black", @table.board, @table.move_history)
        @table.board[61] = Knight.new("Nw", 61, "white", @table.board, @table.move_history)
        @table.board[51] = Rook.new("Kb", 51, "black", @table.board, @table.move_history)
        bw = @table.board[19]
        bk = @table.board[63]
        rook = @table.board[51]
        knight = @table.board[35]
        bishop = @table.board[25]
        queen = @table.board[30]
        pawn = @table.board[10]
        loop do
            @table.prepare_turn
        end


    end

end

Game.new.gameplay