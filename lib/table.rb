require_relative "modules"
require_relative "history"

class Table
    attr_accessor :white, :black, :move_history, :turn

    include Navigation, Check, SaveLoad, PastMoves, BoardState

    TOP_BORDER = (0..7).to_a
    LEFT_BORDER = [0, 8, 16, 24, 32, 40, 48, 56]
    RIGHT_BORDER = [7, 15, 23, 31, 39, 47, 55, 63]
    BOTTOM_BORDER = (56..63).to_a
    ALL_BORDERS = TOP_BORDER.dup.concat(LEFT_BORDER.dup).concat(RIGHT_BORDER.dup).concat(BOTTOM_BORDER.dup).uniq

    def initialize
        @turn = 1
        BoardState.populate_board(BoardState.prepare_pieces[0], BoardState.prepare_pieces[1])
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
        BoardState.display_board
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

    def check_promotion
        pawn = find_promotable_pawn
        if !pawn.nil?
            promote_pawn(pawn, input_promotion)
        end
    end

    def find_promotable_pawn
        pawn = nil
        TOP_BORDER.each do | square |
            if BoardState.board[square].class.ancestors.include?(Piece)
                pawn = BoardState.board[square] if BoardState.board[square].class.name == "Pawn"
            end
        end
        BOTTOM_BORDER.each do | square |
            if BoardState.board[square].class.ancestors.include?(Piece)
                pawn = BoardState.board[square] if BoardState.board[square].class.name == "Pawn"
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
            BoardState.board[pawn.position] = Queen.new("???", pawn.position, pawn.color) if @turn.odd?
            BoardState.board[pawn.position] = Queen.new("???", pawn.position, pawn.color) if !@turn.odd?
        when "bishop"
            BoardState.board[pawn.position] = Bishop.new("???", pawn.position, pawn.color) if @turn.odd?
            BoardState.board[pawn.position] = Bishop.new("???", pawn.position, pawn.color) if !@turn.odd?
        when "knight"
            BoardState.board[pawn.position] = Knight.new("???", pawn.position, pawn.color) if @turn.odd?
            BoardState.board[pawn.position] = Knight.new("???", pawn.position, pawn.color) if !@turn.odd?
        when "rook"
            BoardState.board[pawn.position] = Rook.new("???", pawn.position, pawn.color) if @turn.odd?
            BoardState.board[pawn.position] = Rook.new("???", pawn.position, pawn.color) if !@turn.odd?
            BoardState.board[position].displaced = 1
        end
    end

end