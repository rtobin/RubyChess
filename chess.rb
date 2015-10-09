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
    until @playboard.checkmate?(@current_player.color)
      move
      switch_players
    end

    puts "#{@next_player} wins!"
  end

  def move
    if @current_player.is_a?(ChessAI)
    else
      while true
        start_pos = select_piece(@current_player.color)
        end_pos = select_target
        break if end_pos
      end
    end

    @playboard.move(start_pos, end_pos)
  end

  def select_piece(color)
    selected_pos = @screen.selected_pos
    until selected_pos
      input = @screen.interact
      if input.is_a?(Array)
        space = @playboard[input]
        if space.is_a?(Piece) && space.color == color
          selected_pos = input
          plays = @playboard.possible_moves(@playboard[input])
          plays.select! { |move| @playboard.valid_move?(space, move) }
          if plays.empty?
            selected_pos = nil
            plays = nil
          end
        end
      end

      @screen.plays = plays
      @screen.selected_pos = selected_pos

    end

    selected_pos
  end

  def select_target
    while true
      break if (input = @screen.interact)
    end

    if input == :unselect || (input.is_a?(Array) && @screen.plays.include?(input))
      @screen.selected_pos = nil
      @screen.plays = nil
      return input unless input  == :unselect
    end

    nil
  end

  def switch_players
    @current_player, @next_player = @next_player, @current_player
  end


end

if __FILE__ == $PROGRAM_NAME
  ryan = Player.new("Ryan")
  tracy = Player.new("Tracy")
  game = Chess.new(ryan, tracy)
  game.play
end
