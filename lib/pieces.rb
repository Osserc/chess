require_relative "pieces_modules"

class Piece
    include Moves, Navigation
end

class King < Piece
    attr_accessor :position
    attr_reader :symbol, :color

    STANDARD_MOVESET = [-19, -8, -7, 1, 9, 8, 7, -1]

    def initialize(symbol = nil, position = nil, color = nil)
        @symbol = symbol
        @position = position
        @color = color
    end

end

class Queen < Piece
    attr_accessor :position
    attr_reader :symbol, :color

    # in order: up left, up right, down left, down right, up, down, left, right
    STANDARD_MOVESET = [[-9, -18, -27, -36, -45, -54, -63], [-7, -14, -21, -28, -35, -42, -49], [7, 14, 21, 28, 35, 42, 49], [9, 18, 27, 36, 45, 54, 63], [-8, -16, -24, -32, -40, -48, -56], [8, 16, 24, 32, 40, 48, 56], [-1, -2, -3, -4, -5, -6, -7], [1, 2, 3, 4, 5, 6, 7]]

    def initialize(symbol = nil, position = nil, color = nil)
        @symbol = symbol
        @position = position
        @color = color
    end

end

class Bishop < Piece
    attr_accessor :position
    attr_reader :symbol, :color

    # in order: up left, up right, down left, down right
    STANDARD_MOVESET = [[-9, -18, -27, -36, -45, -54, -63], [-7, -14, -21, -28, -35, -42, -49], [7, 14, 21, 28, 35, 42, 49], [9, 18, 27, 36, 45, 54, 63]]

    def initialize(symbol = nil, position = nil, color = nil)
        @symbol = symbol
        @position = position
        @color = color
    end

end

class Knight < Piece
    attr_accessor :position
    attr_reader :symbol, :color

    STANDARD_MOVESET = [-17, -15, 17, 15, -10, 6, 10, -6]
   
    def initialize(symbol = nil, position = nil, color = nil)
        @symbol = symbol
        @position = position
        @color = color
    end

end

class Rook < Piece
    attr_accessor :position
    attr_reader :symbol, :color

    # in order: up, down, left, right
    STANDARD_MOVESET = [[-8, -16, -24, -32, -40, -48, -56], [8, 16, 24, 32, 40, 48, 56], [-1, -2, -3, -4, -5, -6, -7], [1, 2, 3, 4, 5, 6, 7]]

    def initialize(symbol = nil, position = nil, color = nil)
        @symbol = symbol
        @position = position
        @color = color
    end
end

class Pawn < Piece
    attr_accessor :position
    attr_reader :symbol, :color

    STANDARD_MOVESET = [-8, 8]

    def initialize(symbol = nil, position = nil, color = nil)
        @symbol = symbol
        @position = position
        @color = color
    end

end