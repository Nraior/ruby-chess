class OwnChekmateChecker
  def self.will_cause_own_checkmate?(moved_fig, board, new_x, new_y)
    own_check = false
    own_king = board.team_king(moved_fig.direction)

    # simulate move
    end_figure = board.figure_at_position(new_x, new_y)
    # remove initial pos
    board.update_inside_field_element(moved_fig.x, moved_fig.y, nil)
    # update to new pos
    board.update_inside_field_element(new_x, new_y, moved_fig)

    # check if enemy figures checks own king
    enemy_figs = board.team_figures(-moved_fig.direction)
    enemy_figs.each do |enemy_figure|
      next unless enemy_figure.available_moves(board).include?([own_king.x, own_king.y])

      own_check = true
      break
    end
    # reset to initial position
    # update moved-to field to initial
    board.update_inside_field_element(new_x, new_y, end_figure)
    # update moved fig to initial
    board.update_inside_field_element(moved_fig.x, moved_fig.y, moved_fig)
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
    enemy_figs = board.enemy_figures(enemy_direction)
    own_king = board.team_king(-enemy_direction)
    enemy_figs.each do |enemy_figure|
      next unless enemy_figure.available_moves(board).include?([own_king.x, own_king.y])

      return true
    end
    false
  end
end
