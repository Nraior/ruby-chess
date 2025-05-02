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
end
