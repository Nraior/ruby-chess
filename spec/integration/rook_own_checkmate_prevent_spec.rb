require './lib/ruby_chess/figures/king'
require './lib/ruby_chess/figures/rook'
require './lib/ruby_chess/board'
require './lib/ruby_chess/field'

describe Rook do
  context 'when one standard move would result in checkmate' do
    subject(:rook) { described_class.new(1, 1, -1) }
    let(:rook_field) { Field.new(nil, nil) }
    let(:king_field) { Field.new(nil, nil) }
    let(:enemy_rook_field_first) { Field.new(nil, nil) }

    let(:king) { King.new(0, 0, -1) }
    let(:enemy_rook_first) { Rook.new(3, 0, 1) }
    let(:board) { Board.new(4, 2) }

    before do
      king_field.occupy(king)
      enemy_rook_field_first.occupy(enemy_rook_first)
      rook_field.occupy(rook)
      allow(board).to receive(:fields).and_return([[king_field, Field.new(nil, nil), Field.new(nil, nil), enemy_rook_field_first],
                                                   [Field.new(nil, nil), rook_field, Field.new(nil, nil),
                                                    Field.new(nil, nil)]])
    end
    it "doesn't return that move " do
      moves = rook.legal_moves(board)
      expect(moves).to eq([[1, 0]])
    end
  end
end
