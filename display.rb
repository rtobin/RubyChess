require_relative "board"
require "colorize"
require_relative "cursorable"
class Display
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0,0]
    @selected = false
  end

  def get_things
    start_pos = get_piece
    end_pos = move_piece

  def get_piece
    until (start_pos = get_input)
      system("clear")
      render
    end
    start_pos
  end

  def move_piece
    until (end_pos = get_input)
      system("clear")
      render
    end
    end_pos
  end

  def empty_board
    @display = Array.new(8) { Array.new(8) {"  "} }
  end

  def render
    empty_board

    (0..7).each do |row|

      (0..7).each do |col|

        if ( row.even? && col.even? ) || ( row.odd? && col.odd? )
          @board[row][col] = @board[row][col].colorize(:background => :blue)
        elsif ( row.even? && col.odd? ) || ( row.odd? && col.even? )
          @board[row][col] = @board[row][col].colorize(:background => :white)
        end

        if row == @cursor_pos[0] && col == @cursor_pos[1]
          @board[row][col] = @board[row][col].colorize(:background => :light_red)
        end
      end
      puts @board[row].join
    end
  end
end
