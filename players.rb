# ai-level
# 0 - look for a check or piece consumption or random
# 1 - 0 and look for move of greatest advancement (of enemy and territory under control)
# 2 - consider opponent's possible move response
# 3 - consider AI possible moves after opponent's possible responses to prevoious

Move = Struct.new(:color, :piece, :start_pos, :end_pos)

class ChessAI
  PIECE_POINTS ={
    pawn:   1.0,
    knight: 2.4,
    bishop: 4.0,
    rook:   6.4,
    queen:  10.4,
    king:   3.0
  }

  S_VAL = 0.5

  attr_reader :name, :color, :pieces_avail

  def initialize(color, board, name = nil, level = 0)
    # level determines "depth" of search
    @name = (name ||= "Chess Master Bot")
    @color = color
    @pieces = pieces_avail
    @prev_move_list = [] # checks the amount of "level" moves ahead
  end

  def move(board)
  end

  def move_score(piece, pos)

  end

  def board_score(board)
    # piece score plus S_VAL * (number of attacked positions)
    # maybe adjust to weight the spaces based on loacation?
    score, enemy_score = 0, 0


  end

  def pieces_avail(board, color)
    board.flatten.inject([]) do |arr, space|
      arr << space  if (space && (space.color == color))
    end

  end

  def enemy_pieces_avail(board, color)
    board.flatten.inject([]) do |arr, space|
      arr << space  if (space && (space.color != color))
    end

  end


end




class ChessMovesTree
end
