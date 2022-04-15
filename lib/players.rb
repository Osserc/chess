
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
            pieces << King.new("♚")
            pieces << Queen.new("♛")
            2.times { pieces << Bishop.new("♝") }
            2.times { pieces << Knight.new("♞") }
            2.times { pieces << Rook.new("♜") }
            8.times { pieces << Pawn.new("♟") }
        else
            pieces << King.new("♔")
            pieces << Queen.new("♕")
            2.times { pieces << Bishop.new("♗") }
            2.times { pieces << Knight.new("♘") }
            2.times { pieces << Rook.new("♖") }
            8.times { pieces << Pawn.new("♙") }
        end
        pieces
    end

end