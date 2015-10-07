require_relative "board"
require_relative "display"


class Chess
  def initialize(player1, player2, board = nil)
    @current_player, @next_player = player1, player2
    @current_player.set_color(:white)
    @next_player.set_color(:black)
    @board = (board ||= Board.starting_board)
    @screen = Display.new(@board)

  end

  def play_round
    #render Display
    #player 1 goes
    #board does things
    #switch players
    #gameover?
  end

  def get_move
    if @current_player.is_a?(ChessAI)
    else
      while true
        start_pos = @screen.get_start_square(@current_player.color)
        end_pos = @screen.get_target_square

      end

  end

  def switch_players
    @current_player, @next_player = @next_player, @current_player
  end

  def gameover?
  end


end
