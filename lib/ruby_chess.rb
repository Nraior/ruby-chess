require_relative 'ruby_chess/board'
require_relative 'ruby_chess/game_controller'
require_relative 'ruby_chess/move_controller'
require_relative 'ruby_chess/game_end_checker'
require_relative 'ruby_chess/game_serializer'

require_relative 'ruby_chess/players/player'
require_relative 'ruby_chess/players/random_bot'
require_relative './ruby_chess/modules/chess_teams'

my_board = Board.create_chess_board
move_controller = MoveController.new
end_checker = GameEndChecker.new
game_serializer = GameSerializer.new

me = Player.new('Damian')
bot_george = RandomBot.new('Andrew', my_board)
bot_george.update_direction(ChessTeams::BOTTOM_TEAM)
# opponent = Player.new('Patrick')
game = GameController.new([me, bot_george], my_board, move_controller, end_checker, game_serializer)

game.start_game
