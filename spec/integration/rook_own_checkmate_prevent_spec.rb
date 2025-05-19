require './lib/ruby_chess/figures/king'
require './lib/ruby_chess/figures/rook'
require './lib/ruby_chess/board'
require './lib/ruby_chess/field'

describe Rook do
  subject(:rook) { described_class.new(1, 1, -1) }
  let(:rook_field) { Field.new(nil, nil) }
  let(:king_field) { Field.new(nil, nil) }
  let(:enemy_rook_field_first) { Field.new(nil, nil) }
  let(:enemy_rook_field_second) { Field.new(nil, nil) }

  let(:king) { King.new(0, 0, -1) }
  let(:enemy_rook_first) { Rook.new(3, 0, 1) }
  let(:enemy_rook_second) { Rook.new(2, 0, 1) }

  let(:board) { Board.new(4, 2) }

  before do
    king_field.occupy(king)
    enemy_rook_field_first.occupy(enemy_rook_first)
    enemy_rook_field_second.occupy(enemy_rook_second)
    rook_field.occupy(rook)
    allow(board).to receive(:fields).and_return([[king_field, Field.new(nil, nil), enemy_rook_field_second, enemy_rook_field_first],
                                                 [Field.new(nil, nil), rook_field, Field.new(nil, nil),
                                                  Field.new(nil, nil)]])
  end

  context 'when can prevent checkmate' do
    it 'returns only that move ' do
      moves = rook.legal_moves(board)
      expect(moves).to eq([[1, 0]])
    end
  end

  context 'when already preventing checkmate' do
    subject(:rook) { described_class.new(2, 0, -1) }
    let(:enemy_rook_first) { Rook.new(4, 0, 1) }
    before do
      allow(board).to receive(:fields).and_return([[king_field, Field.new(nil, nil), rook_field, Field.new(nil, nil), enemy_rook_field_first],
                                                   [Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil),
                                                    Field.new(nil, nil)]])
    end
    it 'returns only moves that still prevents checkmate ' do
      moves = rook.legal_moves(board)
      expect(moves).to eq([[1, 0], [3, 0], [4, 0]])
    end
  end

  context 'when cant prevent checkmate' do
    let(:enemy_rook_first) { Rook.new(1, 0, 1) }
    subject(:rook) { described_class.new(2, 1, -1) }
    before do
      allow(board).to receive(:fields).and_return([[king_field, enemy_rook_field_first, Field.new(nil, nil), Field.new(nil, nil)],
                                                   [Field.new(nil, nil), Field.new(nil, nil), rook_field,
                                                    Field.new(nil, nil)]])
    end
    it 'returns nothing' do
      moves = rook.legal_moves(board)
      expect(moves).to eq([])
    end
  end
end
