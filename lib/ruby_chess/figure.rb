class Figure
  attr_reader :moves_count, :x, :y

  def initialize(current_x, current_y, direction = -1)
    @direction = direction
    @x = current_x
    @y = current_y
    @moves_count = 0
  end

  def proceed_move(x, y)
    return unless x.is_a? Integer
    return unless y.is_a? Integer

    @moves_count += 1
    @x = x
    @y = y
  end

  def symbol
    @figure_controller.symbol
  end

  def available_moves(board)
    throw 'Error'
  end
end
