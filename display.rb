require_relative "cursorable"
require "colorize"
require_relative "pieces"

class Display
  SCREEN_WIDTH = 80
  include Cursorable

  attr_accessor :plays, :selected_pos

  def initialize(playboard)
    @playboard = playboard
    @dim = Board::DIM
    @cursor_pos = [0, 0]
    @selected_pos = nil
    @plays = nil
  end

  def interact
    system("clear")
    render_board
    get_input
  end

  def render_board
    # show eaten white pawns
    puts @playboard.dead_pieces.select do |piece|
      piece.color == white && piece.is_a?(Pawn)
    end.map(&:unicode).join.white.on_black

    # show eaten power pieces
    puts @playboard.dead_pieces.select do |piece|
      piece.color == white && ! piece.is_a?(Pawn)
    end.map(&:unicode).join.white.on_black


    (0...@dim).each do |row|
      line = ""
      (0...@dim).each do |col|
        el = @playboard[[row, col]]
        color = el.color unless el.nil?

        if el.nil?
          space = "  "
        else
          space = el.unicode
          el.color == :white ? space = space.light_white : space = space.colorize(el.color)
        end

        # white square
        if ( row.even? && col.even? ) || ( row.odd? && col.odd? )
          space = space.colorize(:background => :white)

        else # black square
          space = space.colorize(:background => :light_black)
        end

        # selected piece
        space = space.on_light_blue if [row, col] == @selected_pos

        # possible moves
        space = space.on_light_green if @plays && @plays.include?([row, col])

        # cusor position
        space = space.on_light_yellow if [row, col] == @cursor_pos


        line << space
      end

      puts line
    end
  end
end
