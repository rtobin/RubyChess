require_relative "board"
require_relative "display"
require_relative "players"
require_relative "pieces"
require "byebug"


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
      # check if stuck in a loop
      break if @playboard.move_history.length > 150
      move

      switch_players
    end

    puts @playboard.checkmate?(@current_player.color) ? "#{@next_player.name} wins!" : "DRAW!!!"
  end

  def move
    if @current_player.is_a?(ChessAI)
      @screen.render_board(@current_player)
      start_pos, end_pos = @current_player.get_best_move(@playboard)
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
    plays = @screen.plays
    until selected_pos
      input = @screen.interact(@current_player)

      if input.is_a?(Array)
        space = @playboard[input]

        if space.is_a?(Piece) && space.color == color
          selected_pos = input
          plays = @playboard.possible_moves(space).select { |move|  @playboard.valid_move?(space, move) }

          if plays.nil? || plays.empty?
            selected_pos = nil
            plays = []
          end
        end
      end

    end

    @screen.plays = plays;
    @screen.selected_pos = selected_pos
  end

  def select_target

    input = @screen.interact
    (input = @screen.interact) until input

    if input == :unselect
      undo_selection
      return nil
    end

    if input.is_a?(Array) && @screen.plays.include?(input)
      undo_selection
      return input
    end

    nil
  end

  def undo_selection
    @screen.selected_pos = nil
    @screen.plays = nil
  end

  def switch_players
    @current_player, @next_player = @next_player, @current_player
  end


end

if __FILE__ == $PROGRAM_NAME

  puts "What is white's name? (or press enter for super smart AI)"
  p1name = gets.chomp
  player1 = p1name == "" ? ChessAI.new() : Player.new(p1name)
  puts "    " + player1.name if p1name == ""
  puts "\nWhat is black's name? (or press enter for super smart AI)"
  p2name = gets.chomp
  player2 = p2name == "" ? ChessAI.new() : Player.new(p2name)
  puts "    " + player2.name if p2name == ""
  puts "\nReady for chess?"
  game = Chess.new(player1, player2)
  game.play
end
