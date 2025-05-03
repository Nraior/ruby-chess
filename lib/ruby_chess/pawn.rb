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

    upper_left = fields[@y + direction][@x - 1].occupying

    upper_left_eglible_enemy = upper_left_valid && !upper_left.nil? && upper_left.direction != direction

    upper_right = fields[@y + direction][@x + 1].occupying
    upper_right_eglible_enemy = upper_right_valid && !upper_right.nil? && upper_right.direction != direction

    moves.push([@x - 1, @y + @direction]) if upper_left_eglible_enemy
    moves.push([@x + 1, @y + @direction]) if upper_right_eglible_enemy

    moves
  end

  def check_en_passant_moves(board)
    fields = board.fields
    left = fields[@y][@x - 1] if board.valid_move?(@x - 1, @y)
    right = fields[@y][@x + 1] if board.valid_move?(@x + 1, @y)

    # left_eglible_for_kill = left && left.
  end
end
