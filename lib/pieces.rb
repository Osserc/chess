require_relative "pieces_modules"

class Piece
    attr_accessor :position, :board, :moves, :displaced, :move_history
    attr_reader :symbol, :color

    include Moves, Navigation

    def initialize(symbol = nil, position = nil, color = nil, board, move_history)
        @symbol = symbol
        @position = position
        @color = color
        @board = board
        @displaced = 0
        @moves = Array.new
        @move_history = move_history
    end
end

class King < Piece

    STANDARD_MOVESET = [-9, -8, -7, 1, 9, 8, 7, -1]

end

class Queen < Piece

    # in order: up left, up right, down left, down right, up, down, left, right
    STANDARD_MOVESET = [[-9], [-7], [7], [9], [-8], [8], [-1], [1]]

end

class Bishop < Piece

    # in order: up left, up right, down left, down right
    STANDARD_MOVESET = [[-9], [-7], [7], [9]]

end

class Knight < Piece

    STANDARD_MOVESET = [-17, -15, 17, 15, -10, 6, 10, -6]

end

class Rook < Piece

    # in order: up, down, left, right
    STANDARD_MOVESET = [[-8], [8], [-1], [1]]

end

class Pawn < Piece

    STANDARD_MOVESET = [-16, -9, -8, -7, 7, 8, 9, 16]

end