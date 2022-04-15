
require_relative "pieces"
class Player
    attr_reader :color
    attr_accessor :pieces

    def initialize(color = nil)
        @color = color
        @pieces = prepare_pieces
    end

    def prepare_pieces
        pieces = Array.new
        if color == "white"
            pieces << King.new("♚", 4, "white")
            pieces << Queen.new("♛", 3, "white")
            pieces << Bishop.new("♝", 2, "white")
            pieces << Bishop.new("♝", 5, "white")
            pieces << Knight.new("♞", 1, "white")
            pieces << Knight.new("♞", 6, "white")
            pieces << Rook.new("♜", 0, "white")
            pieces << Rook.new("♜", 7, "white")
            pieces << Pawn.new("♟", 8, "white")
            pieces << Pawn.new("♟", 9, "white")
            pieces << Pawn.new("♟", 10, "white")
            pieces << Pawn.new("♟", 11, "white")
            pieces << Pawn.new("♟", 12, "white")
            pieces << Pawn.new("♟", 13, "white")
            pieces << Pawn.new("♟", 14, "white")
            pieces << Pawn.new("♟", 15, "white")
        else
            pieces << King.new("♔", 60, "black")
            pieces << Queen.new("♕", 59, "black")
            pieces << Bishop.new("♗", 58, "black")
            pieces << Bishop.new("♗", 61, "black")
            pieces << Knight.new("♘", 57, "black")
            pieces << Knight.new("♘", 62, "black")
            pieces << Rook.new("♖", 56, "black")
            pieces << Rook.new("♖", 63, "black")
            pieces << Pawn.new("♙", 48, "black")
            pieces << Pawn.new("♙", 49, "black")
            pieces << Pawn.new("♙", 50, "black")
            pieces << Pawn.new("♙", 51, "black")
            pieces << Pawn.new("♙", 52, "black")
            pieces << Pawn.new("♙", 53, "black")
            pieces << Pawn.new("♙", 54, "black")
            pieces << Pawn.new("♙", 55, "black")
        end
        pieces
    end

end