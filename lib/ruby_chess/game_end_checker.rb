require_relative 'modules/chess_teams'
class GameEndChecker
  def game_status(board)
    bottom_team = board.team_figures(ChessTeams::BOTTOM_TEAM)
    up_team = board.team_figures(ChessTeams::UP_TEAM)
    up_team_king = board.team_king(ChessTeams::UP_TEAM)
    bottom_team_king = board.team_king(ChessTeams::BOTTOM_TEAM)

    up_checked = false
    bottom_checked = false
    up_has_moves = false
    bottom_has_moves = false
    bottom_team.each do |fig|
      moves = fig.available_moves(board)
      up_team_king_pos = [up_team_king.x, up_team_king.y]
      up_checked = true if moves.include?(up_team_king_pos)
      bottom_has_moves = true if moves.length > 0
    end

    up_team.each do |fig|
      moves = fig.available_moves(board)
      bottom_team_king_pos = [bottom_team_king.x, bottom_team_king.y]
      bottom_checked = true if moves.include?(bottom_team_king_pos)
      up_has_moves = true if moves.length > 0
    end

    return ChessTeams::BOTTOM_TEAM if up_checked && bottom_has_moves
    return ChessTeams::UP_TEAM if bottom_checked && up_has_moves

    return 0 if !up_has_moves && !bottom_has_moves

    false
  end

  def game_draw?(board)
    bottom_team = board.team_figures(ChessTeams::BOTTOM_TEAM)
    up_team = board.team_figures(ChessTeams::UP_TEAM)

    bottom_has_moves = bottom_team.any do |fig|
      fig.available_moves(board)
    end

    up_has_moves = up_team.any do |fig|
      fig.available_moves(board)
    end

    !bottom_has_moves && !up_has_moves
  end
end
