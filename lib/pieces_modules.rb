module King_Limitations




end

module Queen_Limitations




end

module Bishop_Limitations

    def placeholder(board, moves, destination)
        moves = moves[direction(moves, destination)]
        moves
    end

    def direction(moves, destination)
        diagonal = 0
        moves.each do | direction |
            direction.each do | increments |
                return diagonal if destination == self.position + increments
            end
            diagonal += 1
        end
        diagonal
    end


end

module Knight_Limitations

    UPPER_BOUND = (9..14).to_a
    UPPER_LIMITATIONS = [-17, -15, -10, -6]
    UPPER__BOUND_LIMITATIONS = [-17, -15]
    LEFT_BOUND = [9, 17, 25, 33, 41, 49]
    LEFT_LIMITATIONS = [-17, -10, 6, 15]
    LEFT__BOUND_LIMITATIONS = [-10, 6]
    RIGHT_BOUND = [14, 22, 30, 38, 46, 54]
    RIGHT_LIMITATIONS = [-15, -6, 10, 17]
    RIGHT_BOUND_LIMITATIONS = [-6, 10]
    LOWER_BOUND = (49..54).to_a
    LOWER_LIMITATIONS = [17, 15, 10, 6]
    LOWER__BOUND_LIMITATIONS = [17, 15]

    def check_borders(moves)
        moves -= UPPER_LIMITATIONS if Board::TOP_BORDER.include?(self.position) 
        moves -= UPPER__BOUND_LIMITATIONS if UPPER_BOUND.include?(self.position)
        moves -= LEFT_LIMITATIONS if Board::LEFT_BORDER.include?(self.position)
        moves -= LEFT__BOUND_LIMITATIONS if LEFT_BOUND.include?(self.position)
        moves -= RIGHT_LIMITATIONS if Board::RIGHT_BORDER.include?(self.position)
        moves -= RIGHT_BOUND_LIMITATIONS if RIGHT_BOUND.include?(self.position)
        moves -= LOWER_LIMITATIONS if Board::BOTTOM_BORDER.include?(self.position)
        moves -= LOWER__BOUND_LIMITATIONS if LOWER_BOUND.include?(self.position)
        moves
    end

end

module Rook_Limitations



end

module Pawn_Limitations
    
    def check_status(moves)
        moves -= [-8] if self.color == "white"
        moves -= [8] if self.color == "black"
        moves
    end

end

module Moves

    include Navigation, King_Limitations, Queen_Limitations, Bishop_Limitations, Knight_Limitations, Rook_Limitations, Pawn_Limitations

    def move_piece(board, destination)
        if check_legality(board, destination)
            board.board[@position] = " "
            @position = destination
            board.board[destination] = self
        else
            puts "Illegal move."
            move_piece(board, select_destination)
        end
    end

    def check_legality(board, destination)
        moves = define_moveset(board, destination)
        differential = destination - @position
        return false if moves.nil?
        return true if moves.include?(differential)
        return false
    end

    def define_moveset(board, destination)
        case self.class.name
        when "Bishop"
            moves = Array.new.concat(self.class::STANDARD_MOVESET)
            moves = placeholder(board, moves, destination)
        when "Knight"
            moves = Array.new.concat(self.class::STANDARD_MOVESET)
            moves = check_borders(moves)
        when "Pawn"
            moves = Array.new.concat(self.class::STANDARD_MOVESET)
            moves = check_status(moves)
        end
    end

    def check_borders_distance(board)
        distance_up, distance_down = vertical_distance(board)
        distance_right, distance_left = horizontal_distance(board)
        return distance_up, distance_down, distance_right, distance_left
    end

    def vertical_distance(board)
        dummy = Integer(self.position)
        jumps = 0
        until Board::TOP_BORDER.include?(dummy) do
            dummy -= 8
            jumps += 1
        end
        distance_up = jumps
        distance_down = 8 - jumps - 1
        return distance_up, distance_down
    end

    def horizontal_distance(board)
        right_border = Board::RIGHT_BORDER[Board::RIGHT_BORDER.index { | element | element >= self.position }]
        distance_right = right_border - self.position
        distance_left = 8 - distance_right - 1
        return distance_right, distance_left
    end

end