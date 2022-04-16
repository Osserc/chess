require_relative "board"
require_relative "players"
require_relative "pieces"
require_relative "pieces_modules"
require_relative "modules"

class Game
    include Navigation, Moves

    def initialize
        @board = Board.new
        @white = Player.new("white")
        @black = Player.new("black")
        @turn = 1
    end

    def gameplay
        # @board.populate_board(@white, @black)
        @board.board[27] = Queen.new("R", 27, "white")
        @board.display_board
        piece = @board.board[27]
        loop do
            piece = @board.board[select_piece(@board, @turn)]
            piece.move_piece(@board, select_destination(@board))
            @board.display_board
            @turn += 1
        end
    end

end

Game.new.gameplay