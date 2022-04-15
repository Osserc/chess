require_relative "board"
require_relative "players"
require_relative "pieces"
require_relative "pieces_modules"
require_relative "modules"

class Game

    def initialize
        @board = Board.new
        @white = Player.new("white")
        @black = Player.new("black")
    end

    def gameplay
        @board.display_board

    end

end

Game.new.gameplay