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
    end

    def gameplay
        @board.populate_board(@white, @black)
        @board.display_board
        # piece = @board.board[select_piece]
        # piece.move_piece(@board, select_destination)
        # @board.display_board
    end

    def select_piece
        puts "Which piece would you like to move?"
        input_loop
    end

    def select_destination
        puts "Where would you like it to move?"
        input_loop
    end

    def input_loop
        answer = gets.chomp.upcase
        until check_coords_input(answer)
            puts "Invalid coordinates.\n"
            answer = gets.chomp.upcase
        end
        convert_front_to_back(answer)
    end

    def check_coords_input(input)
        if input.length == 2 && LETTERS.include?(input[0]) && NUMBERS.include?(input[1].to_i)
            return true
        else
            return false
        end
    end

end

Game.new.gameplay