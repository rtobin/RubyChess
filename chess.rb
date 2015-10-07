require_relative "board"
require_relative "display"


class Chess
  def initialize(player1, player2, board = nil)
    @player1, @player2 = player1, player2
    @player1.set_color(:white)
    @player2.set_color(:black)
    @board = (board ||= Board.starting_board)

  end

  def play_round
    #render Display
    #player 1 goes
    #board does things
    #switch players
    #gameover?
  end

  def player_input
    
  end

  def gameover?
  end


end

board = Board.starting_board
pos = [3,3]
board[pos] = Queen.new(pos, :white)
screen = Display.new(board)
screen.get_start_square
