require_relative 'figure'
class Pawn < Figure
  def available_moves(board)
    arr = []
    standard_moves = forward_moves(board)
    arr.push(standard_moves)
    kill_moves = available_kill_moves(board)

    arr.push(kill_moves) # unless available_kill_moves(board).empty?

    en_passant = check_en_passant_moves(board)
    arr.push(en_passant)
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
    enemy_forward_left = board.enemy_at_position?(self, @x - 1, @y + @direction)
    enemy_forward_right = board.enemy_at_position?(self, @x - 1, @y + @direction)

    moves.push([@x - 1, @y + @direction]) if enemy_forward_left
    moves.push([@x + 1, @y + @direction]) if enemy_forward_right

    moves
  end

  def last_move_double_forward?
    return false if position_history.length != 1

    (position_history[0][1] - y).abs == 2
  end

  def check_en_passant_moves(board)
    moves = []
    fields = board.fields

    left = fields[@y][@x - 1].occupying if board.enemy_at_position?(self, @x - 1, @y)
    right = fields[@y][@x + 1].occupying if board.enemy_at_position?(self, @x + 1, @y)

    valid_left = left&.is_a?(self.class) && left.last_move_double_forward?
    valid_right = right&.is_a?(self.class) && right.last_move_double_forward?

    moves.push([@x - 1, @y + direction]) if valid_left
    moves.push([@x + 1, @y + direction]) if valid_right

    moves
    # left_eglible_for_kill = left && left.
  end
end
