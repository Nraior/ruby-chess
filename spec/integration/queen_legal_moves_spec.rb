require './lib/ruby_chess/figures/king'
require './lib/ruby_chess/figures/rook'
require './lib/ruby_chess/figures/queen'
require './lib/ruby_chess/board'
require './lib/ruby_chess/field'
require './lib/ruby_chess/modules/chess_teams'

describe Queen do
  subject(:queen) { described_class.new(1, 1, ChessTeams::BOTTOM_TEAM) }
  let(:queen_field) { Field.new(nil, nil) }
  let(:king_field) { Field.new(nil, nil) }
  let(:enemy_rook_field) { Field.new(nil, nil) }

  let(:king) { King.new(1, 0, ChessTeams::BOTTOM_TEAM) }
  let(:enemy_rook) { Rook.new(3, 0, ChessTeams::UP_TEAM) }

  let(:board) { Board.new(4, 2) }

  before do
    king_field.occupy(king)
    enemy_rook_field.occupy(enemy_rook)
    queen_field.occupy(queen)
    allow(board).to receive(:fields).and_return([[Field.new(nil, nil), king_field, Field.new(nil, nil), enemy_rook_field],
                                                 [Field.new(nil, nil), queen_field, Field.new(nil, nil),
                                                  Field.new(nil, nil)]])
  end

  context 'when can prevent checkmate by block' do
    it 'returns only prevent move ' do
      moves = queen.legal_moves(board)
      expect(moves).to eq([[2, 0]])
    end
  end

  context 'when can prevent checkmate by kill' do
    let(:enemy_rook) { Rook.new(0, 0, ChessTeams::UP_TEAM) }
    before do
      allow(board).to receive(:fields).and_return([[enemy_rook_field, king_field, Field.new(nil, nil), Field.new(nil, nil)],
                                                   [Field.new(nil, nil), queen_field, Field.new(nil, nil),
                                                    Field.new(nil, nil)]])
    end
    it 'returns only prevent kill move ' do
      moves = queen.legal_moves(board)
      expect(moves).to eq([[0, 0]])
    end
  end

  context 'when already preventing checkmate' do
    subject(:queen) { described_class.new(1, 0, ChessTeams::BOTTOM_TEAM) }
    let(:king) { King.new(0, 0, ChessTeams::BOTTOM_TEAM) }
    let(:enemy_rook) { Rook.new(4, 0, ChessTeams::UP_TEAM) }
    before do
      allow(board).to receive(:fields).and_return([[king_field, queen_field, Field.new(nil, nil), Field.new(nil, nil), enemy_rook_field],
                                                   [Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil), Field.new(nil, nil),
                                                    Field.new(nil, nil)]])
    end
    it 'returns only moves that still prevents checkmate ' do
      moves = queen.legal_moves(board)
      expect(moves).to eq([[2, 0], [3, 0], [4, 0]])
    end
  end

  context 'when cant prevent checkmate' do
    let(:enemy_rook) { Rook.new(1, 0, ChessTeams::UP_TEAM) }
    let(:king) { King.new(0, 0, ChessTeams::BOTTOM_TEAM) }
    let(:enemy_rook_second) { Rook.new(3, 0, ChessTeams::UP_TEAM) }
    let(:enemy_second_rook_field) { Field.new(nil, nil) }

    subject(:queen) { described_class.new(1, 1, ChessTeams::BOTTOM_TEAM) }
    before do
      allow(board).to receive(:fields).and_return([[king_field, Field.new(nil, nil), Field.new(nil, nil), enemy_rook_field],
                                                   [enemy_second_rook_field, queen_field, Field.new(nil, nil),
                                                    Field.new(nil, nil)]])
    end
    it 'returns nothing' do
      moves = queen.legal_moves(board)
      expect(moves).to eq([])
    end
  end
end
