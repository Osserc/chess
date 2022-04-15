module King_Limitations

    UPPER_LIMITATIONS = [-9, -8, -7]
    LEFT_LIMITATIONS = [-9, -1, 7]
    RIGHT_LIMITATIONS = [-7, 1, 9]
    LOWER_LIMITATIONS = [9, 8, 7]

    def refine_moveset_king(moves)
        moves -= UPPER_LIMITATIONS if Board::TOP_BORDER.include?(self.position) 
        moves -= LEFT_LIMITATIONS if Board::LEFT_BORDER.include?(self.position)
        moves -= RIGHT_LIMITATIONS if Board::RIGHT_BORDER.include?(self.position)
        moves -= LOWER_LIMITATIONS if Board::BOTTOM_BORDER.include?(self.position)
        moves
    end

end

module Queen_Limitations

    def refine_moveset_queen(board, moves, destination)
        perpendicular = direction(moves, destination)
        moves = moves[perpendicular]
        distance_right, distance_left = check_borders_distance(board)[2, 3]
        case perpendicular
        when 0, 2, 6
            moves = moves.slice(0, distance_left)
        when 1, 3, 7
            moves = moves.slice(0, distance_right)
        end
        moves
    end


end

module Bishop_Limitations

    def refine_moveset_bishop(board, moves, destination)
        diagonal = direction(moves, destination)
        moves = moves[diagonal]
        distance_right, distance_left = check_borders_distance(board)[2, 3]
        case diagonal
        when 0, 2
            moves = moves.slice(0, distance_left)
        when 1, 3
            moves = moves.slice(0, distance_right)
        end
        moves
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

    def refine_moveset_knight(moves)
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

    def refine_moveset_rook(board, moves, destination)
        perpendicular = direction(moves, destination)
        moves = moves[perpendicular]
        distance_right, distance_left = check_borders_distance(board)[2, 3]
        case perpendicular
        when 2
            moves = moves.slice(0, distance_left)
        when 3
            moves = moves.slice(0, distance_right)
        end
        moves
    end

end

module Pawn_Limitations
    
    def refine_moveset_pawn(moves)
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
            move_piece(board, select_destination(board))
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
        when "King"
            moves = Array.new.concat(self.class::STANDARD_MOVESET)
            moves = refine_moveset_king(moves)
        when "Queen"
            moves = Array.new.concat(self.class::STANDARD_MOVESET)
            moves = refine_moveset_queen(board, moves, destination)
        when "Bishop"
            moves = Array.new.concat(self.class::STANDARD_MOVESET)
            moves = refine_moveset_bishop(board, moves, destination)
        when "Knight"
            moves = Array.new.concat(self.class::STANDARD_MOVESET)
            moves = refine_moveset_knight(moves)
        when "Rook"
            moves = Array.new.concat(self.class::STANDARD_MOVESET)
            moves = refine_moveset_rook(board, moves, destination)
        when "Pawn"
            moves = Array.new.concat(self.class::STANDARD_MOVESET)
            moves = refine_moveset_pawn(moves)
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

    def direction(moves, destination)
        line = 0
        moves.each do | direction |
            direction.each do | increments |
                return line if destination == self.position + increments
            end
            line += 1
        end
        line
    end

end