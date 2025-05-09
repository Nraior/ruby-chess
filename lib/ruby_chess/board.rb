require_relative 'field'

class Board
  attr_reader :fields, :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @fields = []
  end

  def create
    @fields = Array.new(@height) do |y|
      Array.new(@width) do |x|
        Field.new(x, y)
      end
    end
  end

  def valid_move?(x, y)
    height = fields.length
    width = fields[0].length

    y < height && x < width && x >= 0 && y >= 0
  end

  def figure_at_position(x, y)
    return nil unless valid_move?(x, y)

    field = fields[y][x]
    field&.occupying
  end

  def enemy_at_position?(own_figure, enemy_x, enemy_y)
    return false unless valid_move?(enemy_x, enemy_y)

    field = fields[enemy_y][enemy_x]

    return false if field.occupying.nil?

    own_figure.direction != field.occupying.direction
  end
end
