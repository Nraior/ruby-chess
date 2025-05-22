require './lib/ruby_chess/figures/king'
require './lib/ruby_chess/figures/rook'
require './lib/ruby_chess/board'
require './lib/ruby_chess/field'
require './lib/ruby_chess/modules/chess_teams'

describe King do
  subject(:king) { described_class.new(1, 1, ChessTeams::BOTTOM_TEAM) }
  let(:king_field) { Field.new(nil, nil) }
  let(:enemy_rook_field) { Field.new(nil, nil) }

  let(:king) { King.new(1, 0, ChessTeams::BOTTOM_TEAM) }
  let(:enemy_rook) { Rook.new(3, 0, ChessTeams::UP_TEAM) }

  let(:board) { Board.new(4, 2) }

  before do
    king_field.occupy(king)
    enemy_rook_field.occupy(enemy_rook)
    allow(board).to receive(:fields).and_return([[Field.new(nil, nil), king_field, Field.new(nil, nil), enemy_rook_field],
                                                 [Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil),
                                                  Field.new(nil, nil)]])
  end

  context 'when can prevent checkmate by escape' do
    it 'returns only escape moves ' do
      moves = king.legal_moves(board)
      expect(moves).to eq([[0, 1], [1, 1], [2, 1]])
    end
  end

  context 'when can prevent checkmate by kill and excape' do
    let(:enemy_rook) { Rook.new(1, 0, ChessTeams::UP_TEAM) }
    let(:king) { King.new(0, 0, ChessTeams::BOTTOM_TEAM) }
    before do
      allow(board).to receive(:fields).and_return([[king_field, enemy_rook_field, Field.new(nil, nil), Field.new(nil, nil)],
                                                   [Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil),
                                                    Field.new(nil, nil)]])
    end
    it 'returns escape & prevent kill moves ' do
      moves = king.legal_moves(board)
      expect(moves).to eq([[1, 0], [0, 1]])
    end
  end

  context 'when cant prevent checkmate' do
    let(:enemy_rook) { Rook.new(3, 0, ChessTeams::UP_TEAM) }
    let(:king) { King.new(0, 0, ChessTeams::BOTTOM_TEAM) }
    let(:enemy_rook_second) { Rook.new(3, 1, ChessTeams::UP_TEAM) }
    let(:enemy_second_rook_field) { Field.new(nil, nil) }

    before do
      allow(board).to receive(:fields).and_return([[king_field, Field.new(nil, nil), Field.new(nil, nil), enemy_rook_field],
                                                   [Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil),
                                                    enemy_second_rook_field],
                                                   [Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil),
                                                    Field.new(nil, nil)]])
      enemy_second_rook_field.occupy(enemy_rook_second)
    end
    it 'returns nothing' do
      moves = king.legal_moves(board)
      expect(moves).to eq([])
    end
  end
end
