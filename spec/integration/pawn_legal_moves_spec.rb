require './lib/ruby_chess/figures/pawn'
require './lib/ruby_chess/figures/king'
require './lib/ruby_chess/figures/rook'
require './lib/ruby_chess/board'
require './lib/ruby_chess/field'
require './lib/ruby_chess/modules/chess_teams'

describe Pawn do
  let(:king) { King.new(0, 0, - 1) }
  let(:enemy_rook_first) { Rook.new(1, 0, ChessTeams::UP_TEAM) }
  let(:enemy_rook_second) { Rook.new(2, 0, ChessTeams::UP_TEAM) }
  let(:board) { Board.new(2, 2) }
  subject(:pawn) { described_class.new(1, 1, ChessTeams::BOTTOM_TEAM) }
  let(:pawn_field) { Field.new(nil, nil) }
  let(:king_field) { Field.new(nil, nil) }
  let(:enemy_rook_field_first) { Field.new(nil, nil) }
  let(:enemy_rook_field_second) { Field.new(nil, nil) }

  before do
    allow(board).to receive(:fields).and_return([[king_field, enemy_rook_field_first, enemy_rook_field_second, Field.new(nil, nil)],
                                                 [Field.new(nil, nil), pawn_field,
                                                  Field.new(nil, nil), Field.new(nil, nil)]])
    king_field.occupy(king)
    enemy_rook_field_first.occupy(enemy_rook_first)
    pawn_field.occupy(pawn)
    allow(pawn).to receive(:moves_count).and_return(1)
  end
  context 'when cant prevent checkmate' do
    before do
      enemy_rook_field_second.occupy(enemy_rook_second)
    end
    it "doesn't return any move " do
      moves = pawn.legal_moves(board)
      expect(moves).to eq([])
    end
  end

  context 'when already blocking checkmate' do
    let(:enemy_rook_first) { Rook.new(3, 1, ChessTeams::UP_TEAM) }
    let(:king) { King.new(0, 1, ChessTeams::BOTTOM_TEAM) }

    before do
      allow(board).to receive(:fields).and_return([[Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil)],
                                                   [king_field, pawn_field, Field.new(nil, nil),
                                                    enemy_rook_field_first]])
    end

    it 'doesnt allow move forward' do
      moves = pawn.legal_moves(board)
      expect(moves).to eq([])
    end
  end

  context 'when can prevent checkmate by kill' do
    let(:enemy_rook_first) { Rook.new(0, 0, ChessTeams::UP_TEAM) }
    let(:king) { King.new(0, 1, ChessTeams::BOTTOM_TEAM) }

    before do
      allow(board).to receive(:fields).and_return([[Field.new(nil, nil), Field.new(nil, nil)],
                                                   [king_field, pawn_field]])
    end

    it 'returns kill move' do
      moves = pawn.legal_moves(board)
      expect(moves).to eq([[1, 0]])
    end
  end
end
