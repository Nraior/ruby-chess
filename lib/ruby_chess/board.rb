require_relative 'field'

class Board
  attr_reader :fields

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
end
