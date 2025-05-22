require './lib/ruby_chess/figures/king'
require './lib/ruby_chess/figures/rook'
require './lib/ruby_chess/modules/chess_teams'

describe King do
  subject(:king) { described_class.new(4, 0, 1) }
  let(:king_field) { double('king_field', { occupying: king }) }
  let(:board) { double('board') }
  let(:empty_field) { double('empty_field', { occupying: nil }) }
  let(:occupied_figure) { double('pawn', { direction: ChessTeams::BOTTOM_TEAM }) }
  let(:another_figure) { double('figure', { occupying: occupied_figure }) }
  let(:cross_figure) { double('rook', { direction: ChessTeams::UP_TEAM }) }
  let(:own_field) { double('figure', { occupying: cross_figure }) }

  before do
    allow(board).to receive(:fields).and_return([[own_field, empty_field, empty_field, empty_field, king_field, empty_field,
                                                  empty_field, own_field]])

    allow(board).to receive(:valid_move?).and_return(true)
    allow(board).to receive(:valid_move?) do |x, y|
      x >= 0 && y >= 0 && y < board.fields.length && x < board.fields[0].length
    end

    allow(board).to receive(:figure_at_position) do |x, y|
      board.fields[y][x].occupying
    end
    allow(cross_figure).to receive(:moves_count).and_return(0)
    allow(board).to receive(:any_team_figures_aims_at_pos?).and_return(false)
    allow(board).to receive(:width).and_return(8)
    allow(cross_figure).to receive(:is_a?).with(Rook).and_return(true)
  end

  context 'when its alone' do
    subject(:king) { described_class.new(2, 2, ChessTeams::UP_TEAM) }

    before do
      allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field],
                                                   [empty_field, empty_field, empty_field, empty_field,
                                                    empty_field],
                                                   [empty_field, empty_field, king_field, empty_field, empty_field],
                                                   [empty_field, empty_field, empty_field, empty_field,
                                                    empty_field],
                                                   [empty_field, empty_field, empty_field, empty_field,
                                                    empty_field]])
      allow(board).to receive(:width).and_return(5)
    end
    it 'returns neighboring positions' do
      moves = king.available_moves(board)
      expect(moves).to eq([[1, 1], [2, 1], [3, 1], [1, 2], [3, 2], [1, 3], [2, 3], [3, 3]])
    end
  end

  context 'when castling is available' do
    before do
    end
    it 'returns castling moves' do
      moves = king.available_moves(board)
      expect(moves).to eq([[3, 0], [5, 0], [2, 0], [6, 0]])
    end
  end

  context 'when king already moved' do
    before do
      king.proceed_move(4, 0)
    end
    it "doesn't return castle moves" do
      moves = king.available_moves(board)
      expect(moves).to eq([[3, 0], [5, 0]])
    end
  end

  context 'when rook moved once' do
    before do
      allow(cross_figure).to receive(:moves_count).and_return(1)
    end
    it "doesn't return its castle move" do
      moves = king.available_moves(board)
      expect(moves).to eq([[3, 0], [5, 0]])
    end
  end

  context 'when one rook moved once' do
    let(:cross_figure_2) { double('rook', { direction: ChessTeams::UP_TEAM }) }
    let(:own_field_2) { double('figure', { occupying: cross_figure_2 }) }

    before do
      allow(board).to receive(:fields).and_return([[own_field, empty_field, empty_field, empty_field, king_field, empty_field,
                                                    empty_field, own_field_2]])
      allow(cross_figure_2).to receive(:moves_count).and_return(1)
    end

    it 'returns only castle move' do
      moves = king.available_moves(board)
      expect(moves).to eq([[3, 0], [5, 0], [2, 0]])
    end
  end

  context 'when road to castle is checked' do
    subject(:king) { described_class.new(4, 1, ChessTeams::UP_TEAM) }
    let(:enemy_blocking_field) { double('enemy_blocking_field', { direction: ChessTeams::BOTTOM_TEAM }) }
    let(:enemy_cross_field) { double('figure', { occupying: enemy_blocking_field }) }
    before do
      allow(board).to receive(:fields).and_return([[empty_field, empty_field, empty_field, empty_field, empty_field, empty_field,
                                                    empty_field, enemy_cross_field], [own_field, empty_field, empty_field, empty_field, king_field, empty_field,
                                                                                      empty_field, own_field]])
      allow(enemy_blocking_field).to receive(:available_moves).and_return([
                                                                            [1, 0], [7, 0]
                                                                          ])
      allow(board).to receive(:any_team_figures_aims_at_pos?).and_return(true)
    end

    it "doesn't return castle moves" do
      moves = king.available_moves(board)
      expect(moves).to eq([[3, 0], [4, 0], [5, 0], [3, 1], [5, 1]])
    end
  end
end
