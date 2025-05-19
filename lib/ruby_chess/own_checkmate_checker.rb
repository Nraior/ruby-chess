class OwnChekmateChecker
  def self.will_cause_own_checkmate?(moved_fig, board, new_x, new_y)
    # simulate move
    end_figure = board.figure_at_position(new_x, new_y)
    # remove initial pos
    initial_x = moved_fig.x
    initial_y = moved_fig.y
    board.update_inside_field_element(moved_fig.x, moved_fig.y, nil)
    # update to new pos
    board.update_inside_field_element(new_x, new_y, moved_fig)
    moved_fig.update_pos(new_x, new_y)

    # check if enemy figures checks own king
    own_check = own_checkmate?(board, -moved_fig.direction)
    # update moved-to field to initial
    board.update_inside_field_element(new_x, new_y, end_figure)
    # update moved fig to initial
    board.update_inside_field_element(initial_x, initial_y, moved_fig)

    moved_fig.update_pos(initial_x, initial_y)
    own_check
  end

  def self.en_passant_cause_own_checkmate?(moved_fig, board, new_x, new_y, direction = 1)
    killed_figure = board.figure_at_position(new_x, new_y + direction)
    # simulate kill figure
    board.update_inside_field_element(new_x, new_y + direction, nil)

    # simulate move
    end_figure = board.figure_at_position(new_x, new_y)
    board.update_inside_field_element(new_x, new_y, self)
    # analyze board
    #
    own_checkmate = own_checkmate?(board, -moved_fig.direction)
    # cleanup
    board.update_inside_field_element(new_x, new_y, end_figure)
    board.update_inside_field_element(moved_fig.x, moved_fig.y, moved_fig)
    board.update_inside_field_element(new_x, new_y + direction, killed_figure)
    own_checkmate
  end

  private

  def self.own_checkmate?(board, enemy_direction)
    enemy_figs = board.team_figures(enemy_direction)
    own_king = board.team_king(-enemy_direction)
    enemy_figs.each do |enemy_figure|
      next unless enemy_figure.available_moves(board).include?([own_king.x, own_king.y])

      return true
    end
    false
  end
end
