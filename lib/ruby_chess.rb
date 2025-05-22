require_relative 'ruby_chess/board'
require_relative 'ruby_chess/game_controller'
require_relative 'ruby_chess/move_controller'

require_relative 'ruby_chess/player'

my_board = Board.create_chess_board
move_controller = MoveController.new

me = Player.new('Damian')
opponent = Player.new('Patrick')

game = GameController.new([me, opponent], my_board, move_controller)

game.start_game
