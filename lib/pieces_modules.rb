module King_Limitations

    UPPER_LIMITATIONS = [-9, -8, -7]
    LEFT_LIMITATIONS = [-9, -1, 7]
    RIGHT_LIMITATIONS = [-7, 1, 9]
    LOWER_LIMITATIONS = [9, 8, 7]

    def refine_moveset_king
        king_borders
        check_friendly
        convert_to_squares
    end

    def king_borders
        self.moves -= UPPER_LIMITATIONS if Table::TOP_BORDER.include?(self.position) 
        self.moves -= LEFT_LIMITATIONS if Table::LEFT_BORDER.include?(self.position)
        self.moves -= RIGHT_LIMITATIONS if Table::RIGHT_BORDER.include?(self.position)
        self.moves -= LOWER_LIMITATIONS if Table::BOTTOM_BORDER.include?(self.position)
    end

end

module Queen_Limitations

    def refine_moveset_queen
        self.moves.each { | direction | check_friendly(direction) }
        build_directions
        convert_to_squares
    end


end

module Bishop_Limitations

    def refine_moveset_bishop
        self.moves.each { | direction | check_friendly(direction) }
        build_directions
        convert_to_squares
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

    def refine_moveset_knight
        check_friendly
        knight_borders
        convert_to_squares
    end

    def knight_borders
        self.moves -= UPPER_LIMITATIONS if Table::TOP_BORDER.include?(self.position) 
        self.moves -= UPPER__BOUND_LIMITATIONS if UPPER_BOUND.include?(self.position)
        self.moves -= LEFT_LIMITATIONS if Table::LEFT_BORDER.include?(self.position)
        self.moves -= LEFT__BOUND_LIMITATIONS if LEFT_BOUND.include?(self.position)
        self.moves -= RIGHT_LIMITATIONS if Table::RIGHT_BORDER.include?(self.position)
        self.moves -= RIGHT_BOUND_LIMITATIONS if RIGHT_BOUND.include?(self.position)
        self.moves -= LOWER_LIMITATIONS if Table::BOTTOM_BORDER.include?(self.position)
        self.moves -= LOWER__BOUND_LIMITATIONS if LOWER_BOUND.include?(self.position)
    end

end

module Rook_Limitations

    def refine_moveset_rook
        self.moves.each { | direction | check_friendly(direction) }
        build_directions
        convert_to_squares
    end

end

module Pawn_Limitations

    WHITE_MOVES = [-16, -9, -8, -7]
    BLACK_MOVES = [7, 8, 9, 16]
    
    def refine_moveset_pawn
        pawn_color_check
        pawn_double_step
        pawn_obstruction
        check_friendly
        pawn_eating
        convert_to_squares
    end

    def pawn_color_check
        self.moves -= BLACK_MOVES if self.color == "black"
        self.moves -= WHITE_MOVES if self.color == "white"
    end

    def pawn_double_step
        self.moves -= [16] if self.color == "white" && self.displaced != 0
        self.moves -= [-16] if self.color == "black" && self.displaced != 0
    end

    def pawn_obstruction
        self.moves -= [16] if self.board[self.position + 16] != " "
        self.moves -= [8] if self.board[self.position + 8] != " "
        self.moves -= [-16] if self.board[self.position - 16] != " "
        self.moves -= [-8] if self.board[self.position - 8] != " "
    end

    def pawn_eating
        self.moves -= [7] if self.board[self.position + 7] == " "
        self.moves -= [9] if self.board[self.position + 9] == " "
        self.moves -= [-7] if self.board[self.position - 7] == " "
        self.moves -= [-9] if self.board[self.position - 9] == " "
    end

end

module Moves

    include Navigation, Check

    def define_moveset
        case self.class.name
        when "King"
            self.moves = self.class::STANDARD_MOVESET.dup
            refine_moveset_king
        when "Queen"
            self.moves = self.class::STANDARD_MOVESET.map { | direction | direction.dup}
            refine_moveset_queen
        when "Bishop"
            self.moves = self.class::STANDARD_MOVESET.map { | direction | direction.dup}
            refine_moveset_bishop
        when "Knight"
            self.moves = self.class::STANDARD_MOVESET.dup
            refine_moveset_knight
        when "Rook"
            self.moves = self.class::STANDARD_MOVESET.map { | direction | direction.dup}
            refine_moveset_rook
        when "Pawn"
            self.moves = self.class::STANDARD_MOVESET.dup
            refine_moveset_pawn
        end
    end

    def check_friendly(moves = self.moves)
        moves.map! do | single_move |
            if self.board[self.position + single_move].class.ancestors.include?(Piece)
                single_move = nil if self.board[self.position + single_move].color == self.color
            end
            single_move
        end
        moves.compact!
    end

    def build_directions
        self.moves.each do | direction |
            unless direction.empty?
                until Table::ALL_BORDERS.include?(self.position + direction.last) do
                    if self.board[self.position + direction.last].class.ancestors.include?(Piece)
                        if self.board[self.position + direction.last].color != self.color
                            break
                        elsif self.board[self.position + direction.last].color == self.color
                            direction.pop
                            break
                        end
                    else
                        direction << direction.last + direction.first
                    end
                end
            end
        end
    end

    def convert_to_squares
        self.moves.flatten!
        self.moves.map! do | single_move |
            single_move += @position
        end
    end

    # def convert_to_squares(moves = self.moves)
    #     moves.map! do | single_move |
    #         single_move += @position
    #     end
    # end

    def move_piece(destination)
        # return if !valid_move?
        log_move(destination)
        self.board[self.position] = " "
        self.position = destination
        self.board[destination] = self
    end

    def valid_move?(destination)
        self.moves.flatten.include?(destination)
    end

    def log_move(destination)
        move = {
            :moved_piece => self,
            :distance_traveled => destination - self.position,
        }
        self.board[destination] == " " ? move[:eaten_piece] = nil : move[:eaten_piece] = self.board[destination]
        self.move_history.append(move)
    end

end