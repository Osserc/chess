module Navigation

    LETTERS = ('A'..'H').to_a
    NUMBERS = (1..8).to_a
    BOARD_UI = LETTERS.map { | l | NUMBERS.map { | n | "#{l}#{n}" } }.flatten

    def convert_back_to_front(index)
        converted = BOARD_UI[index]
        converted
    end

    def convert_front_to_back(coords)
        converted = BOARD_UI.index(coords)
        converted
    end

    def select_piece(board)
        puts "Which piece would you like to move?"
        input_loop_start(board)
    end

    def select_destination(board)
        puts "Where would you like it to move?"
        input_loop_destination(board)
    end

    def input_loop_start(board)
        answer = gets.chomp.upcase
        until check_coords_input(answer) && check_piece_presence(board, answer)
            puts "Invalid coordinates.\n"
            answer = gets.chomp.upcase
        end
        convert_front_to_back(answer)
    end

    def input_loop_destination(board)
        answer = gets.chomp.upcase
        until check_coords_input(answer)
            puts "Invalid coordinates.\n"
            answer = gets.chomp.upcase
        end
        convert_front_to_back(answer)
    end

    def check_coords_input(input)
        if input.length == 2 && LETTERS.include?(input[0]) && NUMBERS.include?(input[1].to_i)
            return true
        else
            return false
        end
    end

    def check_piece_presence(board, input)
        if board.board[convert_front_to_back(input)].class.ancestors.include?(Piece)
            return true
        else
            return false
        end
    end

end