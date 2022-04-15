require_relative "modules"

class Board
    attr_accessor :board

    include Navigation

    TOP_BORDER = (0..7).to_a
    LEFT_BORDER = [0, 8, 16, 24, 32, 40, 48, 56]
    RIGHT_BORDER = [7, 15, 23, 31, 39, 47, 55, 63]
    BOTTOM_BORDER = (56..63).to_a

    def initialize
        @board = make_board
    end

    def make_board
        Array.new(64, " ")
    end

    def display_board
        i = 0
        b = 0
        print "   | " + NUMBERS.join(" | ").to_s + " |\n"
        print "---+---+---+---+---+---+---+---+---+\n"
        until i == 8 && b == 64
            print " " + LETTERS[i] + " | " + @board.slice(b, 8).map { | element | element.class.ancestors.include?("Piece") ? element.symbol : element }.join(" | ").to_s + " |\n"
            print "---+---+---+---+---+---+---+---+---+\n"
            i += 1
            b += 8
        end
    end

end