require_relative 'ruby_chess/board'
require_relative 'ruby_chess/game_controller'
require_relative 'ruby_chess/player'

my_board = Board.create_chess_board

me = Player.new('Damian')
opponent = Player.new('Patrick')

game = GameController.new([me, opponent], my_board)

game.start_game
