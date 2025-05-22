class RandomBot < Player
  def initialize(name, board)
    @name = name
    @board = board
    @selecting_figure = true
    @selected_figure = nil
  end

  def update_direction(direction)
    @direction = direction
  end

  def input
    team_figures = @board.team_figures(@direction)

    acceptable_figures = team_figures.filter do |fig|
      fig.legal_moves(@board).length.positive?
    end

    if @selecting_figure

      @selected_figure = acceptable_figures.sample
      @selecting_figure = !@selecting_figure
    else

      @selecting_figure = !@selecting_figure
      move = @selected_figure.legal_moves(@board).sample
      @selected_figure = nil
      move.join(' ')
    end
  end
end
