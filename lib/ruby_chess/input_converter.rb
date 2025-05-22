class InputConverter
  def input_to_figure(input, board)
    numbers = input.split
    return nil if numbers.length < 2

    return nil unless valid_number?(numbers[0]) && valid_number?(numbers[1])

    board.figure_at_position(numbers[0].to_i, numbers[1].to_i)
  end

  def input_to_array(input)
    numbers = input.split
    return nil if numbers.length < 2

    return nil unless valid_number?(numbers[0]) && valid_number?(numbers[1])

    [numbers[0].to_i, numbers[1].to_i]
  end

  private

  def valid_number?(num)
    num.to_i.to_s == num.to_s
  end
end
