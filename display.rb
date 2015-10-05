require_relative "board"
require "colorize"
require "cursorable"

class Display
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0,0]
    @selected = false
  end


  def render
    # when we render the board
    # the background color should be different
    # where the cursor is
  end
end
