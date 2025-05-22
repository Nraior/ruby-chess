require './lib/ruby_chess/figures/king'
require './lib/ruby_chess/figures/rook'
require './lib/ruby_chess/figures/bishop'
require './lib/ruby_chess/board'
require './lib/ruby_chess/field'
require './lib/ruby_chess/modules/chess_teams.'

describe Bishop do
  subject(:bishop) { described_class.new(1, 1, ChessTeams::BOTTOM_TEAM) }
  let(:bishop_field) { Field.new(nil, nil) }
  let(:king_field) { Field.new(nil, nil) }
  let(:enemy_rook_field) { Field.new(nil, nil) }

  let(:king) { King.new(1, 0, ChessTeams::BOTTOM_TEAM) }
  let(:enemy_rook) { Rook.new(3, 0, ChessTeams::UP_TEAM) }

  let(:board) { Board.new(4, 2) }

  before do
    king_field.occupy(king)
    enemy_rook_field.occupy(enemy_rook)
    bishop_field.occupy(bishop)
    allow(board).to receive(:fields).and_return([[Field.new(nil, nil), king_field, Field.new(nil, nil), enemy_rook_field],
                                                 [Field.new(nil, nil), bishop_field, Field.new(nil, nil),
                                                  Field.new(nil, nil)]])
  end

  context 'when can prevent checkmate by block' do
    it 'returns only prevent move ' do
      moves = bishop.legal_moves(board)
      expect(moves).to eq([[2, 0]])
    end
  end

  context 'when can prevent checkmate by kill' do
    let(:enemy_rook) { Rook.new(0, 0, ChessTeams::UP_TEAM) }
    before do
      allow(board).to receive(:fields).and_return([[enemy_rook_field, king_field, Field.new(nil, nil), Field.new(nil, nil)],
                                                   [Field.new(nil, nil), bishop_field, Field.new(nil, nil),
                                                    Field.new(nil, nil)]])
    end
    it 'returns only prevent kill move ' do
      moves = bishop.legal_moves(board)
      expect(moves).to eq([[0, 0]])
    end
  end

  context 'when already preventing checkmate' do
    subject(:bishop) { described_class.new(1, 0, ChessTeams::BOTTOM_TEAM) }
    let(:king) { King.new(0, 0, ChessTeams::BOTTOM_TEAM) }
    let(:enemy_rook) { Rook.new(4, 0, 1) }
    before do
      allow(board).to receive(:fields).and_return([[king_field, bishop_field, Field.new(nil, nil), Field.new(nil, nil), enemy_rook_field],
                                                   [Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil),
                                                    Field.new(nil, nil)]])
    end
    it 'returns only moves that still prevents checkmate ' do
      moves = bishop.legal_moves(board)
      expect(moves).to eq([])
    end
  end

  context 'when cant prevent checkmate' do
    let(:enemy_rook) { Rook.new(1, 0, ChessTeams::UP_TEAM) }
    let(:king) { King.new(0, 0, ChessTeams::BOTTOM_TEAM) }

    subject(:bishop) { described_class.new(1, 1, ChessTeams::BOTTOM_TEAM) }
    before do
      allow(board).to receive(:fields).and_return([[king_field, enemy_rook_field, Field.new(nil, nil), Field.new(nil, nil)],
                                                   [Field.new(nil, nil), bishop_field, Field.new(nil, nil),
                                                    Field.new(nil, nil)]])
    end
    it 'returns nothing' do
      moves = bishop.legal_moves(board)
      expect(moves).to eq([])
    end
  end
end
