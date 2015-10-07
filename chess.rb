require_relative "board"
require_relative "display"
require_relative "players"
require_relative "pieces"


class Chess
  def initialize(player1, player2, board = nil)
    @current_player, @next_player = player1, player2
    @current_player.set_color(:white)
    @next_player.set_color(:black)
    @playboard = (board ||= Board.starting_board)
    @screen = Display.new(@playboard)

  end

  def play
    while true
      move
      switch_players
    end
  end

  def move
    if @current_player.is_a?(ChessAI)
    else
      while true
        start_pos = @screen.get_start_square(@current_player.color)
        end_pos = @screen.get_target_square

        break if end_pos
      end
    end

    @playboard.move(start_pos, end_pos)
  end

  def switch_players
    @current_player, @next_player = @next_player, @current_player
  end

  def gameover?
  end


end

if __FILE__ == $PROGRAM_NAME
  ryan = Player.new("Ryan")
  tracy = Player.new("Tracy")
  game = Chess.new(ryan, tracy)
  game.play
end
