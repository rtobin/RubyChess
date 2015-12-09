# ai-level
# 0 - look for a check or piece consumption or random
# 1 - 0 and look for move of greatest advancement (of enemy and territory under control)
# 2 - consider opponent's possible move response
# 3 - consider AI possible moves after opponent's possible responses to prevoious

# Move = Struct.new(:color, :piece, :start_pos, :end_pos)

class Player
  attr_reader :name, :color

  def initialize(name, board = nil)
    # doesn't do anything with board
    @name = name
  end

  def set_color(color)
    @color = color
  end
end

class ChessAI < Player

  # the relative value of a square under attack
  S_VAL = 0.5

  attr_reader :pieces

  def initialize(name = nil, board = nil, level = 1)
    # level determines "depth" of search
    name ||= ["Chess Master Bot", "Robo", "God", "Rex", "Terminator", "Lover",
      "I Robot", "Rosey", "MechaGodzilla", "Tron", "Wall-E", "Fembot", "Dot Matrix",
      "Skynet", "Sonny", "Optimus Prime", "C-3PO", "Agent Smith", "Robocop", "R2D2",
      "HAL 9000"].sample

    super(name, board)
    @prev_move_list = [] # checks the amount of "level" moves ahead
    @color == :white ? @enemy_color = :black : @enemy_color = :white
    @level = level

  end

  def get_best_move(board)
    # samples if no best move
    # only checks one level ahead
    best_move = board.all_valid_moves(@color).shuffle.max_by do |start_pos, end_pos|
      # basic ai is just the next line and comment everything else in the block
      # move_score(board, start_pos, end_pos)

      trial_board = board.dup
      trial_board.move(start_pos, end_pos)
      trial_board.all_valid_moves(@enemy_color).inject(0) do |accum, move|
        accum + move_score(trial_board, move[0], move[1])
      end
    end
  end

  def move_score(board, start_pos, end_pos)
    piece = board[start_pos]
    return nil unless piece.is_a?(Piece)
    trial_board = board.dup
    trial_board.move(start_pos, end_pos)
    board_score(trial_board, color)
  end

  def board_score(board, color)
    # piece score plus S_VAL * (number of attacked positions)
    # maybe adjust to weight the spaces based on loacation?
    score = 0
    enemy_score = 0

    good_move_scores = pieces_on_board(board).map do |piece|
      subscore = board.valid_moves(piece).inject(0) do |sum, end_pos|
        board[end_pos].nil? ? sum + S_VAL : sum + board[end_pos].score
      end

      piece.color == color ? score += subscore : enemy_score += subscore
    end

    score - enemy_score
  end

  def num_moves(board, color)
    sum = 0
    pieces_on_board(board).each do |piece|
      if piece.color == color
        sum += board.valid_moves(piece).count
      end
    end

    sum
  end

  def pieces_on_board(board)
    board.grid.flatten.select { |square| square.is_a?(Piece) }
  end

end




class ChessMovesTree
end
