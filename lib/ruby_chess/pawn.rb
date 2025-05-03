require_relative 'figure'
class Pawn < Figure
  def available_moves(board)
    arr = []
    standard_moves = forward_moves(board)
    arr.push(standard_moves)
    kill_moves = available_kill_moves(board)

    arr.push(kill_moves) # unless available_kill_moves(board).empty?

    arr.flatten(1)
  end

  def forward_moves(board)
    moves = []
    fields = board.fields

    ending_iterator_adder = moves_count.zero? ? 1 : 0

    start = @y + @direction
    end_index = start + (@direction * ending_iterator_adder)

    loop_iterator = start > end_index ? start.downto(end_index) : (start..end_index)

    loop_iterator.each do |n|
      x_pos = @x

      next unless board.valid_move?(n, x_pos)

      return moves unless fields[n][x_pos].occupying.nil?

      moves.push([x_pos, n])
    end
    moves
  end

  def available_kill_moves(board)
    moves = []
    fields = board.fields

    upper_left_valid = board.valid_move?(@x - 1, @y + @direction)
    upper_right_valid = board.valid_move?(@x + 1, @y + @direction)
    moves.push([@x - 1, @y + @direction]) if upper_left_valid && !fields[@y + @direction][@x - 1].occupying.nil?
    moves.push([@x + 1, @y + @direction]) if upper_right_valid && !fields[@y + @direction][@x + 1].occupying.nil?

    moves
  end
end
