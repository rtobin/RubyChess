


class Chess
  def initialize(board = nil)
    @players = [1, 2]
    @board = Board.new(board)
  end

  def play_round
    #render Display
    #player 1 goes
    #board does things
    #switch players
    #gameover?
  end

  def player_input
    begin
      start_pos = get_piece
      retry if @board.empty_space?(start_pos)
      end_pos = move_piece
      retry if @board.invalid_move?(start_pos, end_pos)
    end
    [start_pos, end_pos].move_logic
  end

  def gameover?
  end


end
