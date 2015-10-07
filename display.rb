require_relative "cursorable"
require "colorize"
require_relative "pieces"

class Display
  include Cursorable

  def initialize(playboard)
    @playboard = playboard
    @dim = Board::DIM
    @cursor_pos = [0, 0]
    @selected_pos = nil
    @plays = nil
  end

  def get_start_square(color)
    until @selected_pos
      system("clear")
      render_board
      input = get_input
      if input.is_a?(Array)
        space = @playboard[input]
        if space.is_a?(Piece) && space.color == color
          @selected_pos = input
          @plays = @playboard.possible_moves(@playboard[input])
          @plays.select { |move| @playboard.valid_move?(space, move) }
          if @plays.empty?
            @selected_pos = nil
            @plays = nil
          end
        end
      end
    end

    system("clear")
    render_board
    @selected_pos
  end

  def get_target_square
    system("clear")
    render_board
    input = get_input

    until input
      system("clear")
      render_board
      input = get_input
    end

    if input == :unselect
      @selected_pos = nil
      @plays = nil
      return nil
    end

    if input.is_a?(Array) && @plays.include?(input)
      @selected_pos = nil
      @plays = nil
      return input
    end      

    nil

  end

  def render_board # dummy board
    (0...@dim).each do |row|
      line = ""
      (0...@dim).each do |col|
        el = @playboard[[row, col]]
        color = el.color unless el.nil?

        # cusor position
        if [row, col] == @cursor_pos
          if el.nil?
            space =  "".ljust(2).on_light_yellow
          else
            space = el.unicode[0].ljust(2).colorize(:color => el.color).on_light_yellow
          end

        # selected piece
      elsif [row, col] == @selected_pos
          if el.nil?
            space =  "".ljust(2).on_light_blue
          else
            space = el.unicode[0].ljust(2).colorize(:color => el.color).on_light_blue
          end

        # possible moves
      elsif @plays && @plays.include?([row, col])
          if el.nil?
            space =  "".ljust(2).on_light_green
          else
            space = el.unicode[0].ljust(2).colorize(:color => el.color).on_light_green
          end

        # white square
        elsif ( row.even? && col.even? ) || ( row.odd? && col.odd? )
          if el.nil?
            space =  "".ljust(2).on_white
          else
            el.color == :white ? space = el.unicode[1] : space = el.unicode[0]
            space = space.ljust(2).black.on_white
          end

        # black square
        else
          if el.nil?
            space =  "".ljust(2).on_black
          else
            el.color == :black ? space = el.unicode[1] : space = el.unicode[0]
            space = space.ljust(2).white.on_black
          end
        end

        line << space
      end

      puts line
    end
  end
end
