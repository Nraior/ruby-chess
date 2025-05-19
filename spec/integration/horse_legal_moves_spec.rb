require './lib/ruby_chess/figures/king'
require './lib/ruby_chess/figures/rook'
require './lib/ruby_chess/figures/horse'
require './lib/ruby_chess/board'
require './lib/ruby_chess/field'

describe Horse do
  subject(:horse) { described_class.new(2, 2, -1) }
  let(:horse_field) { Field.new(nil, nil) }
  let(:king_field) { Field.new(nil, nil) }
  let(:enemy_rook_field) { Field.new(nil, nil) }

  let(:king) { King.new(0, 0, -1) }
  let(:enemy_rook) { Rook.new(4, 0, 1) }

  let(:board) { Board.new(4, 2) }

  before do
    king_field.occupy(king)
    enemy_rook_field.occupy(enemy_rook)
    horse_field.occupy(horse)
    allow(board).to receive(:fields).and_return([[king_field, Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil), enemy_rook_field],
                                                 [Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil),
                                                  Field.new(nil, nil), Field.new(nil, nil)],
                                                 [Field.new(nil, nil), Field.new(nil, nil), horse_field,
                                                  Field.new(nil, nil), Field.new(nil, nil)],
                                                 [Field.new(nil, nil), Field.new(nil, nil),  Field.new(nil, nil),
                                                  Field.new(nil, nil), Field.new(nil, nil)],
                                                 [Field.new(nil, nil), Field.new(nil, nil),  Field.new(nil, nil),
                                                  Field.new(nil, nil), Field.new(nil, nil)]])
  end

  context 'when can prevent checkmate by block' do
    it 'returns only prevent move ' do
      moves = horse.legal_moves(board)
      expect(moves).to eq([[1, 0], [3, 0]])
    end
  end

  context 'when can prevent checkmate by kill' do
    let(:enemy_rook) { Rook.new(0, 1, 1) }
    before do
      allow(board).to receive(:fields).and_return([[king_field, Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil)],
                                                   [enemy_rook_field, Field.new(nil, nil), Field.new(nil, nil),
                                                    Field.new(nil, nil), Field.new(nil, nil)],

                                                   [Field.new(nil, nil), Field.new(nil, nil), horse_field,
                                                    Field.new(nil, nil), Field.new(nil, nil)],
                                                   [Field.new(nil, nil), Field.new(nil, nil),  Field.new(nil, nil),
                                                    Field.new(nil, nil), Field.new(nil, nil)],
                                                   [Field.new(nil, nil), Field.new(nil, nil),  Field.new(nil, nil),
                                                    Field.new(nil, nil), Field.new(nil, nil)]])
    end
    it 'returns only prevent kill move ' do
      moves = horse.legal_moves(board)
      expect(moves).to eq([[0, 1]])
    end
  end

  context 'when already preventing checkmate' do
    subject(:horse) { described_class.new(1, 0, -1) }
    let(:king) { King.new(0, 0, -1) }
    let(:enemy_rook) { Rook.new(4, 0, 1) }
    before do
      allow(board).to receive(:fields).and_return([[king_field, horse_field, Field.new(nil, nil), Field.new(nil, nil), enemy_rook_field],
                                                   [Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil),
                                                    Field.new(nil, nil), Field.new(nil, nil)],

                                                   [Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil),
                                                    Field.new(nil, nil), Field.new(nil, nil)],
                                                   [Field.new(nil, nil), Field.new(nil, nil),  Field.new(nil, nil),
                                                    Field.new(nil, nil), Field.new(nil, nil)],
                                                   [Field.new(nil, nil), Field.new(nil, nil),  Field.new(nil, nil),
                                                    Field.new(nil, nil), Field.new(nil, nil)]])
    end
    it 'returns only moves that still prevents checkmate ' do
      moves = horse.legal_moves(board)
      expect(moves).to eq([])
    end
  end

  context 'when cant prevent checkmate' do
    let(:enemy_rook) { Rook.new(0, 2, 1) }
    let(:king) { King.new(0, 0, -1) }

    subject(:horse) { described_class.new(1, 1, -1) }
    before do
      allow(board).to receive(:fields).and_return([[king_field, Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil)],
                                                   [Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil),
                                                    Field.new(nil, nil), Field.new(nil, nil)],

                                                   [enemy_rook_field, Field.new(nil, nil), horse_field,
                                                    Field.new(nil, nil), Field.new(nil, nil)],
                                                   [Field.new(nil, nil), Field.new(nil, nil),  Field.new(nil, nil),
                                                    Field.new(nil, nil), Field.new(nil, nil)],
                                                   [Field.new(nil, nil), Field.new(nil, nil),  Field.new(nil, nil),
                                                    Field.new(nil, nil), Field.new(nil, nil)]])
    end
    it 'returns nothing' do
      moves = horse.legal_moves(board)
      expect(moves).to eq([])
    end
  end
end
