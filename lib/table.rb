require_relative "modules"
require_relative "history"

class Table
    attr_accessor :board, :white, :black, :move_history, :turn

    include Navigation, Check, SaveLoad, PastMoves

    TOP_BORDER = (0..7).to_a
    LEFT_BORDER = [0, 8, 16, 24, 32, 40, 48, 56]
    RIGHT_BORDER = [7, 15, 23, 31, 39, 47, 55, 63]
    BOTTOM_BORDER = (56..63).to_a
    ALL_BORDERS = TOP_BORDER.dup.concat(LEFT_BORDER.dup).concat(RIGHT_BORDER.dup).concat(BOTTOM_BORDER.dup).uniq

    def initialize
        @board = make_board
        @turn = 1
        populate_board(prepare_pieces[0], prepare_pieces[1])
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

    def populate_board(white, black)
        white.each do | element |
            @board[element.position] = element
        end
        black.each do | element |
            @board[element.position] = element
        end
    end

    def prepare_pieces
        white = Array.new
        black = Array.new

        white << King.new("♚", 3, "white", @board)
        white << Queen.new("♛", 4, "white", @board)
        white << Bishop.new("♝", 2, "white", @board)
        white << Bishop.new("♝", 5, "white", @board)
        white << Knight.new("♞", 1, "white", @board)
        white << Knight.new("♞", 6, "white", @board)
        white << Rook.new("♜", 0, "white", @board)
        white << Rook.new("♜", 7, "white", @board)
        white << Pawn.new("♟", 8, "white", @board)
        white << Pawn.new("♟", 9, "white", @board)
        white << Pawn.new("♟", 10, "white", @board)
        white << Pawn.new("♟", 11, "white", @board)
        white << Pawn.new("♟", 12, "white", @board)
        white << Pawn.new("♟", 13, "white", @board)
        white << Pawn.new("♟", 14, "white", @board)
        white << Pawn.new("♟", 15, "white", @board)

        black << King.new("♔", 59, "black", @board)
        black << Queen.new("♕", 60, "black", @board)
        black << Bishop.new("♗", 58, "black", @board)
        black << Bishop.new("♗", 61, "black", @board)
        black << Knight.new("♘", 57, "black", @board)
        black << Knight.new("♘", 62, "black", @board)
        black << Rook.new("♖", 56, "black", @board)
        black << Rook.new("♖", 63, "black", @board)
        black << Pawn.new("♙", 48, "black", @board)
        black << Pawn.new("♙", 49, "black", @board)
        black << Pawn.new("♙", 50, "black", @board)
        black << Pawn.new("♙", 51, "black", @board)
        black << Pawn.new("♙", 52, "black", @board)
        black << Pawn.new("♙", 53, "black", @board)
        black << Pawn.new("♙", 54, "black", @board)
        black << Pawn.new("♙", 55, "black", @board)

        return white, black
    end

    def play_round
        prepare_turn
        presentation
        piece = selection_loop
        destination = select_destination(piece)
        piece.move_piece(destination)
        check_promotion
        self.turn += 1
    end

    def prepare_turn
        display_board
        generate_legal_moves
        check_endgame
    end

    def presentation
        if @turn.odd?
            puts "White's turn."
        else
            puts "Black's turn."
        end
    end

    def regenerate_moveset(set)
        set.each do | piece |
            piece.define_moveset
        end
    end

    def revert_move
        move = PastMoves.move_history.find_last.value
        piece_to_move_back = move[:moved_piece]
        piece_to_move_back.displaced -= 1
        distance_traveled = move[:distance_traveled]
        piece_to_resurrect = move[:eaten_piece]
        piece_to_resurrect.nil? ? @board[piece_to_move_back.position] = " " : @board[piece_to_move_back.position] = piece_to_resurrect
        piece_to_move_back.position -= distance_traveled
        @board[piece_to_move_back.position] = piece_to_move_back
        revert_move_castling(move) if move.key?(:castled)
        revert_move_en_passant(move) if move.key?(:en_passant)
        PastMoves.move_history.pop
    end

    def revert_move_castling(move)
        rook = move[:castled][:rook]
        distance = move[:castled][:distance]
        @board[rook.position] = " "
        rook.position -= distance
        @board[rook.position] = rook
    end

    def revert_move_en_passant(move)
        pawn = move[:en_passant][:pawn]
        @board[pawn.position] = pawn
    end

    def check_promotion
        pawn = find_promotable_pawn
        if !pawn.nil?
            promote_pawn(pawn, input_promotion)
        end
    end

    def find_promotable_pawn
        pawn = nil
        TOP_BORDER.each do | square |
            if @board[square].class.ancestors.include?(Piece)
                pawn = @board[square] if @board[square].class.name == "Pawn"
            end
        end
        BOTTOM_BORDER.each do | square |
            if @board[square].class.ancestors.include?(Piece)
                pawn = @board[square] if @board[square].class.name == "Pawn"
            end
        end
        pawn
    end

    def input_promotion
        puts "A pawn can be promoted. What piece do you want it to become?"
        answer = gets.chomp.downcase
        until ["queen", "bishop", "knight", "rook"].include?(answer) do
            puts "Invalid input."
            answer = gets.chomp.downcase
        end
        answer
    end

    def promote_pawn(pawn, answer)
        position = pawn.position.dup
        case answer
        when "queen"
            @board[pawn.position] = Queen.new("♛", pawn.position, pawn.color, @board) if @turn.odd?
            @board[pawn.position] = Queen.new("♕", pawn.position, pawn.color, @board) if !@turn.odd?
        when "bishop"
            @board[pawn.position] = Bishop.new("♝", pawn.position, pawn.color, @board) if @turn.odd?
            @board[pawn.position] = Bishop.new("♗", pawn.position, pawn.color, @board) if !@turn.odd?
        when "knight"
            @board[pawn.position] = Knight.new("♞", pawn.position, pawn.color, @board) if @turn.odd?
            @board[pawn.position] = Knight.new("♘", pawn.position, pawn.color, @board) if !@turn.odd?
        when "rook"
            @board[pawn.position] = Rook.new("♜", pawn.position, pawn.color, @board) if @turn.odd?
            @board[pawn.position] = Rook.new("♖", pawn.position, pawn.color, @board) if !@turn.odd?
            @board[position].displaced = 1
        end
    end

end