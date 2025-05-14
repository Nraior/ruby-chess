require_relative './king'
class Figure
  attr_reader :moves_count, :x, :y, :position_history, :direction

  def initialize(current_x, current_y, direction = -1)
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

    @x = new_x
    @y = new_y
  end

  def symbol
    @figure_controller.symbol
  end

  def available_moves(board)
    []
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

  def move_results_in_own_check?(board, new_x, new_y)
    own_check = false
    own_king = board.team_king(direction)

    # simulate move
    end_figure = board.figure_at_position(new_x, new_y)
    update_figure_pos(self, new_x, new_y)

    # check if enemy figures checks own king
    enemy_figs = board.enemy_figures(-direction)
    enemy_figs.each do |enemy_figure|
      next unless enemy_figure.available_moves(board).include([own_king.x, own_king.y])

      own_check = true
      break
    end
    # reset to initial position
    board.update_figure_pos(end_figure, new_x, new_y)
    board.update_figure_pos(self, x, y)
    own_check
  end
end
