require_relative 'figure'
class Horse < Figure
  def available_moves(board)
    vectors_to_check = [[-1, -2], [-2, -1], [1, -2], [2, -1], [-1, 2], [-2, 1], [2, 1], [1, 2]]
    moves = []
    vectors_to_check.each do |vector|
      checked = field(vector[0], vector[1], board)
      moves.push(checked)
    end
    moves.compact
  end

  private

  def field(x_vector, y_vector, board)
    return nil unless board.valid_move?(x + x_vector, y + y_vector)

    fig = board.figure_at_position(x + x_vector, y + y_vector)

    [x + x_vector, y + y_vector] if fig.nil? || enemy?(fig)
  end

  def symbol_pool
    ['♘', '♞']
  end
end
