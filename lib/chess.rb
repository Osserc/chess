require_relative "table"
require_relative "pieces"
require_relative "pieces_modules"
require_relative "modules"
require_relative "history"

class Game

    include Navigation, Moves

    def initialize
        @table = Table.new
    end

    def gameplay
        welcome
        gameplay_loop
    end

    def welcome
        puts "Welcome to this simple game of chess.\nTwo human players, taking turn, first type the coordinates of the piece they wish to move, for example B1 for the left-most white pawn, and then the coordinates of where they want to move it, like D1 to make the aforementioned pawn perform a double step.\nIn addition, players are able to save the boardstate - or load one from memory - by typing either 'save' or 'load' before selecting a piece.\nHave fun!"
    end

    def gameplay_loop
        loop do
            @table.play_round
        end
    end

end

Game.new.gameplay