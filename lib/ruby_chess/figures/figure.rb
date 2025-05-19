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

    update_pos(new_x, new_y)
  end

  def update_pos(x, y)
    @x = x
    @y = y
  end

  def symbol
    @figure_controller.symbol
  end

  def available_moves(board)
    []
  end

  def legal_moves(board)
    available_moves(board)
  end

  def enemy?(other_figure)
    return false if other_figure.nil?

    other_figure.direction != direction
  end

  def ally?(other_figure)
    return false if other_figure.nil?

    other_figure.direction == direction
  end
end
