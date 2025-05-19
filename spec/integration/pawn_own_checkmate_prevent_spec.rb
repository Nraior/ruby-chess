require './lib/ruby_chess/figures/pawn'
require './lib/ruby_chess/figures/king'
require './lib/ruby_chess/figures/rook'
require './lib/ruby_chess/board'
require './lib/ruby_chess/field'

describe Pawn do
  context 'when one standard move would result in checkmate' do
    subject(:pawn) { described_class.new(1, 1, -1) }
    let(:pawn_field) { Field.new(nil, nil) }
    let(:empty_field) { Field.new(nil, nil) }
    let(:king_field) { Field.new(nil, nil) }
    let(:enemy_rook_field_first) { Field.new(nil, nil) }
    let(:enemy_rook_field_second) { Field.new(nil, nil) }

    let(:king) { King.new(0, 0, - 1) }
    let(:enemy_rook_first) { Rook.new(1, 0, 1) }
    let(:enemy_rook_second) { Rook.new(2, 0, 1) }
    let(:board) { Board.new(8, 7) }

    before do
      king_field.occupy(king)
      enemy_rook_field_first.occupy(enemy_rook_first)
      enemy_rook_field_second.occupy(enemy_rook_second)
      pawn_field.occupy(pawn)
      allow(board).to receive(:fields).and_return([[king_field, enemy_rook_field_first, enemy_rook_field_second, empty_field],
                                                   [empty_field, pawn_field,
                                                    empty_field, empty_field]])
      allow(pawn).to receive(:moves_count).and_return(1)
      allow(OwnChekmateChecker).to receive(:will_cause_own_checkmate?).and_call_original
      allow(OwnChekmateChecker).to receive(:en_passant_cause_own_checkmate?).and_call_original
    end
    it "doesn't return that move " do
      moves = pawn.legal_moves(board)
      expect(moves).to eq([])
    end
  end
end
