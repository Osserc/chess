module King_Limitations

    UPPER_LIMITATIONS = [-9, -8, -7]
    LEFT_LIMITATIONS = [-9, -1, 7]
    RIGHT_LIMITATIONS = [-7, 1, 9]
    LOWER_LIMITATIONS = [9, 8, 7]

    def refine_moveset_king
        king_borders
        check_friendly
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
    end


end

module Bishop_Limitations

    def refine_moveset_bishop
        self.moves.each { | direction | check_friendly(direction) }
        build_directions
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
    end

end

module Pawn_Limitations

    WHITE_MOVES = [-16, -9, -8, -7]
    BLACK_MOVES = [7, 8, 9, 16]]
    
    def refine_moveset_pawn(moves)
        check_friendly
        pawn_color_check
        pawn_double_step
        pawn_obstruction
        pawn_eating
    end

    def pawn_color_check
        self.moves -= BLACK_MOVES if self.color == "black"
        self.moves -= WHITE_MOVES if self.color == "white"
    end

    def pawn_double_step
        self.moves -= [16] if self.color == "white" && self.displace != 0
        self.moves -= [-16] if self.color == "black" && self.displace != 0
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

    include Navigation, King_Limitations, Queen_Limitations, Bishop_Limitations, Knight_Limitations, Rook_Limitations, Pawn_Limitations

    def define_moveset
        case self.class.name
        when "King"
            self.moves = Array.new.concat(self.class::STANDARD_MOVESET)
            refine_moveset_king
        when "Queen"
            self.moves = Array.new.concat(self.class::STANDARD_MOVESET)
            refine_moveset_queen
        when "Bishop"
            self.moves = Array.new.concat(self.class::STANDARD_MOVESET)
            refine_moveset_bishop
        when "Knight"
            self.moves = Array.new.concat(self.class::STANDARD_MOVESET)
            refine_moveset_knight
        when "Rook"
            self.moves = Array.new.concat(self.class::STANDARD_MOVESET)
            refine_moveset_rook
        when "Pawn"
            self.moves = Array.new.concat(self.class::STANDARD_MOVESET)
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

end

    # def move_piece(board, destination)
    #     if check_legality(board, destination)
    #         board.board[@position] = " "
    #         @position = destination
    #         board.board[destination] = self
    #     else
    #         puts "Illegal move."
    #         move_piece(board, select_destination(board))
    #     end
    # end

    # def check_legality(board, destination)
    #     if board.board[destination].class.ancestors.include?(Piece)
    #         return false if board.board[destination].color == @color
    #     end
    #     moves = define_moveset(board, destination)
    #     differential = destination - @position
    #     return false if moves.nil?
    #     return true if moves.include?(differential)
    #     return false
    # end

    # def check_horizontal_distance(board)
    #     right_border = Board::RIGHT_BORDER[Board::RIGHT_BORDER.index { | element | element >= self.position }]
    #     distance_right = right_border - self.position
    #     distance_left = 8 - distance_right - 1
    #     return distance_right, distance_left
    # end

    # def check_vertical_distance(board)
    #     jumps = 0
    #     dummy = Integer(@position)
    #     until Board::TOP_BORDER.include?(dummy) do
    #         dummy += 8
    #         jumps += 1
    #     end
    #     distance_up = jumps
    #     distance_down = 8 - distance_up - 1
    #     return distance_up, distance_down
    # end