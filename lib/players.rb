
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
            pieces << King.new("♚", 4)
            pieces << Queen.new("♛", 3)
            pieces << Bishop.new("♝", 2)
            pieces << Bishop.new("♝", 5)
            pieces << Knight.new("♞", 1)
            pieces << Knight.new("♞", 6)
            pieces << Rook.new("♜", 0)
            pieces << Rook.new("♜", 7)
            pieces << Pawn.new("♟", 8)
            pieces << Pawn.new("♟", 9)
            pieces << Pawn.new("♟", 10)
            pieces << Pawn.new("♟", 11)
            pieces << Pawn.new("♟", 12)
            pieces << Pawn.new("♟", 13)
            pieces << Pawn.new("♟", 14)
            pieces << Pawn.new("♟", 15)
        else
            pieces << King.new("♔", 60)
            pieces << Queen.new("♕", 59)
            pieces << Bishop.new("♗", 58)
            pieces << Bishop.new("♗", 61)
            pieces << Knight.new("♘", 57)
            pieces << Knight.new("♘", 62)
            pieces << Rook.new("♖", 56)
            pieces << Rook.new("♖", 63)
            pieces << Pawn.new("♙", 48)
            pieces << Pawn.new("♙", 49)
            pieces << Pawn.new("♙", 50)
            pieces << Pawn.new("♙", 51)
            pieces << Pawn.new("♙", 52)
            pieces << Pawn.new("♙", 53)
            pieces << Pawn.new("♙", 54)
            pieces << Pawn.new("♙", 55)
        end
        pieces
    end

end