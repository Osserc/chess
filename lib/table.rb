require_relative "modules"
require_relative "history"

class Table
    attr_accessor :board, :white, :black, :move_history

    include Navigation

    TOP_BORDER = (0..7).to_a
    LEFT_BORDER = [0, 8, 16, 24, 32, 40, 48, 56]
    RIGHT_BORDER = [7, 15, 23, 31, 39, 47, 55, 63]
    BOTTOM_BORDER = (56..63).to_a
    ALL_BORDERS = TOP_BORDER.concat(LEFT_BORDER).concat(RIGHT_BORDER).concat(BOTTOM_BORDER).uniq

    def initialize
        @board = make_board
        @white = Array.new
        @black = Array.new
        # prepare_pieces
        # populate_board
        @move_history = MoveHistory.new
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
            print " " + LETTERS[i] + " | " + @board.slice(b, 8).map { | element | element.class.ancestors.include?(Piece) ? element.symbol : element }.join(" | ").to_s + " |\n"
            print "---+---+---+---+---+---+---+---+---+\n"
            i += 1
            b += 8
        end
    end

    def populate_board
        @white.each do | element |
            @board[element.position] = element
        end
        @black.each do | element |
            @board[element.position] = element
        end
    end

    def prepare_pieces
        @white << King.new("♚", 4, "white", @board)
        @white << Queen.new("♛", 3, "white", @board)
        @white << Bishop.new("♝", 2, "white", @board)
        @white << Bishop.new("♝", 5, "white", @board)
        @white << Knight.new("♞", 1, "white", @board)
        @white << Knight.new("♞", 6, "white", @board)
        @white << Rook.new("♜", 0, "white", @board)
        @white << Rook.new("♜", 7, "white", @board)
        @white << Pawn.new("♟", 8, "white", @board, @move_history)
        @white << Pawn.new("♟", 9, "white", @board, @move_history)
        @white << Pawn.new("♟", 10, "white", @board, @move_history)
        @white << Pawn.new("♟", 11, "white", @board, @move_history)
        @white << Pawn.new("♟", 12, "white", @board, @move_history)
        @white << Pawn.new("♟", 13, "white", @board, @move_history)
        @white << Pawn.new("♟", 14, "white", @board, @move_history)
        @white << Pawn.new("♟", 15, "white", @board, @move_history)

        @black << King.new("♔", 60, "black", @board)
        @black << Queen.new("♕", 59, "black", @board)
        @black << Bishop.new("♗", 58, "black", @board)
        @black << Bishop.new("♗", 61, "black", @board)
        @black << Knight.new("♘", 57, "black", @board)
        @black << Knight.new("♘", 62, "black", @board)
        @black << Rook.new("♖", 56, "black", @board)
        @black << Rook.new("♖", 63, "black", @board)
        @black << Pawn.new("♙", 48, "black", @board, @move_history)
        @black << Pawn.new("♙", 49, "black", @board, @move_history)
        @black << Pawn.new("♙", 50, "black", @board, @move_history)
        @black << Pawn.new("♙", 51, "black", @board, @move_history)
        @black << Pawn.new("♙", 52, "black", @board, @move_history)
        @black << Pawn.new("♙", 53, "black", @board, @move_history)
        @black << Pawn.new("♙", 54, "black", @board, @move_history)
        @black << Pawn.new("♙", 55, "black", @board, @move_history)
    end

end