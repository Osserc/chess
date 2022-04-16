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
        distance_right, distance_left = check_horizontal_distance(board)
        moves[0] = moves[0].slice(0, distance_left)
        moves[2] = moves[2].slice(0, distance_left)
        moves[6] = moves[6].slice(0, distance_left)
        moves[1] = moves[1].slice(0, distance_right)
        moves[3] = moves[3].slice(0, distance_right)
        moves[7] = moves[7].slice(0, distance_right)
        moves.flatten
    end


end

module Bishop_Limitations

    def refine_moveset_bishop(board, moves, destination)
        distance_right, distance_left = check_horizontal_distance(board)
        moves[0] = moves[0].slice(0, distance_left)
        moves[2] = moves[2].slice(0, distance_left)
        moves[1] = moves[1].slice(0, distance_right)
        moves[3] = moves[3].slice(0, distance_right)
        moves.flatten
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
        distance_right, distance_left = check_horizontal_distance(board)
        moves[2] = moves[2].slice(0, distance_left)
        moves[3] = moves[3].slice(0, distance_right)
        moves.flatten
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

    def check_horizontal_distance(board)
        right_border = Board::RIGHT_BORDER[Board::RIGHT_BORDER.index { | element | element >= self.position }]
        distance_right = right_border - self.position
        distance_left = 8 - distance_right - 1
        return distance_right, distance_left
    end

end