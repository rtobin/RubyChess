require_relative "cursorable"
require "colorize"
require_relative "pieces"

class Display
  SCREEN_WIDTH = 80

  PIECE_COLORS = { white: :white,
                  black: :black
  }

  COLOR_LIGHT_SQUARE = :light_cyan
  COLOR_DARK_SQUARE  = :cyan
  COLOR_BORDER       = :light_blue
  COLOR_CURSOR       = :light_cyan
  COLOR_MOVES        = :light_green
  COLOR_CHECKED_KING = :red
  BORDER_SPACE       = "    ".colorize(background: COLOR_BORDER)

  include Cursorable



  attr_accessor :plays, :selected_pos

  def initialize(playboard)
    @playboard = playboard
    @dim = Board::DIM
    @cursor_pos = [0, 0]
    @selected_pos = nil
    @plays = nil
    # @ai = ChessAI.new
  end

  def interact(current_player)
    render_board(current_player)
    # puts @ai.board_score(@playboard, :white)
    # puts @ai.num_moves(@playboard, :white)
    # puts @ai.get_best_move(@playboard)
    get_input
  end

  def render_board(current_player)
    # show eaten white pawns
    system("clear")
    white_pawns = @playboard.dead_pieces.select do |piece|
      piece.color == :white && piece.is_a?(Pawn)
    end
    pawns_str = white_pawns.map(&:unicode).join.ljust(24)

    puts pawns_str.colorize(background: COLOR_BORDER, color: PIECE_COLORS[:white])

    # show eaten white power pieces
    white_non_pawns = @playboard.dead_pieces.select do |piece|
      piece.color == :white && ! piece.is_a?(Pawn)
    end

    non_pawns_str = white_non_pawns.map(&:unicode).join.ljust(24)
    puts non_pawns_str.colorize(background: COLOR_BORDER, color: PIECE_COLORS[:white])


    (0...@dim).each do |row|
      line = ""
      (0...@dim).each do |col|
        el = @playboard[[row, col]]
        color = el.color unless el.nil?

        if el.nil?
          space = "  "
        else
          space = el.unicode
          space = space.colorize(color: PIECE_COLORS[el.color])
        end

        # white square
        if ( row.even? && col.even? ) || ( row.odd? && col.odd? )
          space = space.colorize(background: COLOR_LIGHT_SQUARE)

        else # black square
          space = space.colorize(background: COLOR_DARK_SQUARE)
        end

        # selected piece
        space = space.on_light_blue if [row, col] == @selected_pos

        # possible moves
        space = space.on_light_green if @plays && @plays.include?([row, col])

        # cusor position
        unless current_player.is_a?(ChessAI)
          space = space.on_light_yellow if [row, col] == @cursor_pos
        end
        # highlight in check king red
        space = space.on_light_red if el.is_a?(King) && @playboard.in_check?(color)

        line << space
      end

      puts BORDER_SPACE + line + BORDER_SPACE
    end

    # show eaten black power pieces
    black_non_pawns = @playboard.dead_pieces.select do |piece|
      piece.color == :black && ! piece.is_a?(Pawn)
    end
    non_pawns_str = black_non_pawns.map(&:unicode).join.ljust(24)
    puts non_pawns_str.colorize(background: COLOR_BORDER, color: PIECE_COLORS[:black])

    # show eaten black pawns
    black_pawns = @playboard.dead_pieces.select do |piece|
      piece.color == :black && piece.is_a?(Pawn)
    end
    pawns_str = black_pawns.map(&:unicode).join.ljust(24)
    puts pawns_str.colorize(background: COLOR_BORDER, color: PIECE_COLORS[:black])
    display_detail = current_player.is_a?(ChessAI) ? "AI level #{current_player.level}" : "human"
    puts "  #{current_player.name}'s (#{display_detail}) turn  "
    # puts @playboard.move_history.map(&:to_s).join(",")
    puts "\nCTRL+C to exit game..."
  end
end
