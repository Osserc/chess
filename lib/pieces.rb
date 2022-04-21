require_relative "pieces_modules"

class Piece
    attr_accessor :position, :moves, :displaced
    attr_reader :symbol, :color

    include Moves, Navigation, PastMoves, BoardState

    def initialize(symbol = nil, position = nil, color = nil)
        @symbol = symbol
        @position = position
        @color = color
        @displaced = 0
        @moves = Array.new
    end
end

class King < Piece
    include King_Limitations

    STANDARD_MOVESET = [-9, -8, -7, 1, 9, 8, 7, -1]

end

class Queen < Piece
    include Queen_Limitations

    # in order: up left, up right, down left, down right, up, down, left, right
    STANDARD_MOVESET = [[-9], [-7], [7], [9], [-8], [8], [-1], [1]]

end

class Bishop < Piece
    include Bishop_Limitations

    # in order: up left, up right, down left, down right
    STANDARD_MOVESET = [[-9], [-7], [7], [9]]

end

class Knight < Piece
    include Knight_Limitations

    STANDARD_MOVESET = [-17, -15, 17, 15, -10, 6, 10, -6]

end

class Rook < Piece
    include Rook_Limitations

    # in order: up, down, left, right
    STANDARD_MOVESET = [[-8], [8], [-1], [1]]

end

class Pawn < Piece
    include Pawn_Limitations

    STANDARD_MOVESET = [-16, -9, -8, -7, 7, 8, 9, 16]

end