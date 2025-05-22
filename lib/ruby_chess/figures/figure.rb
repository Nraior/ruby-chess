require_relative '../own_checkmate_checker'
require_relative '../modules/chess_teams'
require_relative '../modules/chess_teams'
class Figure
  attr_reader :moves_count, :x, :y, :position_history, :direction

  def initialize(current_x, current_y, direction = ChessTeams::BOTTOM_TEAM)
    @direction = direction
    @x = current_x
    @y = current_y
    @position_history = []
    @moves_count = 0
  end

  def proceed_move(new_x, new_y)
    return unless new_x.is_a? Integer
    return unless new_y.is_a? Integer

    @moves_count += 1
    @position_history.push([x, y])

    update_pos(new_x, new_y)
  end

  def update_pos(x, y)
    @x = x
    @y = y
  end

  def symbol
    direction == ChessTeams::UP_TEAM ? symbol_pool[0] : symbol_pool[1]
  end

  def to_s
    symbol
  end

  def available_moves(board)
    []
  end

  def legal_moves(board)
    moves = available_moves(board)
    moves.filter do |move|
      !OwnChekmateChecker.will_cause_own_checkmate?(self, board, move[0], move[1])
    end
  end

  def enemy?(other_figure)
    return false if other_figure.nil?

    other_figure.direction != direction
  end

  def ally?(other_figure)
    return false if other_figure.nil?

    other_figure.direction == direction
  end

  private

  def symbol_pool
    %w[x y]
  end
end
