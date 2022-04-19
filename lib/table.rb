require_relative "modules"
require_relative "history"

class Table
    attr_accessor :board, :white, :black, :move_history

    include Navigation, Check

    TOP_BORDER = (0..7).to_a
    LEFT_BORDER = [0, 8, 16, 24, 32, 40, 48, 56]
    RIGHT_BORDER = [7, 15, 23, 31, 39, 47, 55, 63]
    BOTTOM_BORDER = (56..63).to_a
    ALL_BORDERS = TOP_BORDER.dup.concat(LEFT_BORDER.dup).concat(RIGHT_BORDER.dup).concat(BOTTOM_BORDER.dup).uniq

    def initialize
        @board = make_board
        @white = Array.new
        @black = Array.new
        @turn = 1
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
        @white << King.new("♚", 4, "white", @board, @move_history)
        @white << Queen.new("♛", 3, "white", @board, @move_history)
        @white << Bishop.new("♝", 2, "white", @board, @move_history)
        @white << Bishop.new("♝", 5, "white", @board, @move_history)
        @white << Knight.new("♞", 1, "white", @board, @move_history)
        @white << Knight.new("♞", 6, "white", @board, @move_history)
        @white << Rook.new("♜", 0, "white", @board, @move_history)
        @white << Rook.new("♜", 7, "white", @board, @move_history)
        @white << Pawn.new("♟", 8, "white", @board, @move_history)
        @white << Pawn.new("♟", 9, "white", @board, @move_history)
        @white << Pawn.new("♟", 10, "white", @board, @move_history)
        @white << Pawn.new("♟", 11, "white", @board, @move_history)
        @white << Pawn.new("♟", 12, "white", @board, @move_history)
        @white << Pawn.new("♟", 13, "white", @board, @move_history)
        @white << Pawn.new("♟", 14, "white", @board, @move_history)
        @white << Pawn.new("♟", 15, "white", @board, @move_history)

        @black << King.new("♔", 60, "black", @board, @move_history)
        @black << Queen.new("♕", 59, "black", @board, @move_history)
        @black << Bishop.new("♗", 58, "black", @board, @move_history)
        @black << Bishop.new("♗", 61, "black", @board, @move_history)
        @black << Knight.new("♘", 57, "black", @board, @move_history)
        @black << Knight.new("♘", 62, "black", @board, @move_history)
        @black << Rook.new("♖", 56, "black", @board, @move_history)
        @black << Rook.new("♖", 63, "black", @board, @move_history)
        @black << Pawn.new("♙", 48, "black", @board, @move_history)
        @black << Pawn.new("♙", 49, "black", @board, @move_history)
        @black << Pawn.new("♙", 50, "black", @board, @move_history)
        @black << Pawn.new("♙", 51, "black", @board, @move_history)
        @black << Pawn.new("♙", 52, "black", @board, @move_history)
        @black << Pawn.new("♙", 53, "black", @board, @move_history)
        @black << Pawn.new("♙", 54, "black", @board, @move_history)
        @black << Pawn.new("♙", 55, "black", @board, @move_history)
    end

    def play_round
        prepare_turn


        @turn += 1
    end

    def prepare_turn
        display_board
        collect_pieces_all
        regenerate_moveset_all
        purge_illegal_moves
        possible_moves = count_moves
        puts possible_moves
        if @turn.odd?
            puts "Game over" if in_check?(@black, "white") && possible_moves.empty?
            puts "Stalemate" if !in_check?(@black, "white") && possible_moves.empty?
        else
            puts "Game over" if in_check?(@white, "black") && possible_moves.empty?
            puts "Stalemate" if !in_check?(@white, "black") && possible_moves.empty?
        end
    end

    def collect_pieces_all
        @white = collect_set("white")
        @black = collect_set("black")
    end

    def regenerate_moveset_all
        regenerate_moveset(@white)
        regenerate_moveset(@black)
    end

    def regenerate_moveset(set)
        set.each do | piece |
            piece.define_moveset
        end
    end

    def revert_move
        move = @move_history.find_last
        piece_to_move_back = move.value[:moved_piece]
        distance_traveled = move.value[:distance_traveled]
        piece_to_resurrect = move.value[:eaten_piece]
        piece_to_resurrect.nil? ? @board[piece_to_move_back.position] = " " : @board[piece_to_move_back.position] = piece_to_resurrect
        piece_to_move_back.position -= distance_traveled
        @board[piece_to_move_back.position] = piece_to_move_back
        @move_history.pop
    end

end