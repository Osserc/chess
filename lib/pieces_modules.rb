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

module Moves

    include Knight_Limitations

    def move_piece(board, destination)
        if check_legality(destination)
            board.board[@position] = " "
            @position = destination
            board.board[destination] = self
        else
            puts "Illegal move."
        end
    end

    def define_moveset
        case self.class.name
        when "Knight"
            moves = Array.new.concat(self.class::STANDARD_MOVESET)
            moves = check_borders(moves)
        end
    end

    def check_legality(destination)
        moves = define_moveset
        differential = destination - @position
        return true if moves.include?(differential)
        return false
    end

end