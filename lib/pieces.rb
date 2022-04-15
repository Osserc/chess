require_relative "pieces_modules"

class Piece
    include Moves, Navigation
end

class King < Piece
    attr_accessor :position
    attr_reader :symbol

    STANDARD_MOVESET = [-17, -15, 17, 15, -10, 6, 10, -6]

    def initialize(symbol = nil, position = nil)
        @symbol = symbol
        @position = position
    end

end

class Queen < Piece
    attr_accessor :position
    attr_reader :symbol

    STANDARD_MOVESET = [-17, -15, 17, 15, -10, 6, 10, -6]

    def initialize(symbol = nil, position = nil)
        @symbol = symbol
        @position = position
    end

end

class Bishop < Piece
    attr_accessor :position
    attr_reader :symbol

    STANDARD_MOVESET = [-17, -15, 17, 15, -10, 6, 10, -6]

    def initialize(symbol = nil, position = nil)
        @symbol = symbol
        @position = position
    end

end

class Knight < Piece
    attr_accessor :position
    attr_reader :symbol

    STANDARD_MOVESET = [-17, -15, 17, 15, -10, 6, 10, -6]

    def initialize(symbol = nil, position = nil)
        @symbol = symbol
        @position = position
    end

end

class Rook < Piece
    attr_accessor :position
    attr_reader :symbol

    STANDARD_MOVESET = [-17, -15, 17, 15, -10, 6, 10, -6]

    def initialize(symbol = nil, position = nil)
        @symbol = symbol
        @position = position
    end
end

class Pawn < Piece
    attr_accessor :position
    attr_reader :symbol

    STANDARD_MOVESET = [-17, -15, 17, 15, -10, 6, 10, -6]

    def initialize(symbol = nil, position = nil)
        @symbol = symbol
        @position = position
    end

end