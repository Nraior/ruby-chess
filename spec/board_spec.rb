require './lib/ruby_chess/board'
require './lib/ruby_chess/field'

describe Board do
  subject(:board) { described_class.new(8, 8) }
  let(:field) { double('field') }
  let(:occupied_figure) { double('figure', { direction: 1 }) }
  let(:another_figure) { double('figure', { occupying: occupied_figure }) }
  let(:empty_field) { double('figure', { occupying: nil }) }

  describe('#create') do
    before do
      allow(Field).to receive(:new).and_return(field)
    end

    it 'creates board with 64 fields' do
      board.create
      fields_count = board.fields.flatten.length
      expect(fields_count).to eq(64)
    end
  end

  describe('#valid_move?') do
    before do
      board.create
    end
    it('returns true left_up (0, 0] position') do
      valid = board.valid_move?(0, 4)
      expect(valid).to eq(true)
    end

    it('returns true for right,  down (7,7) position') do
      valid = board.valid_move?(7, 7)
      expect(valid).to eq(true)
    end

    it('returns false for negeative position') do
      valid = board.valid_move?(-1, -1)
      expect(valid).to eq(false)
    end

    it('returns false for after position over board') do
      valid = board.valid_move?(8, 8)
      expect(valid).to eq(false)
    end
  end

  describe '#figure_at_position' do
    before do
      allow(board).to receive(:fields).and_return([[another_figure, empty_field]])
    end
    it 'returns nil for incorrect pos' do
      result = board.figure_at_position(-1, -1)
      expect(result).to eq(nil)
    end

    it 'returns figure for correct field' do
      result = board.figure_at_position(0, 0)
      expect(result).to eq(occupied_figure)
    end

    it 'returns nil for empty field' do
      result = board.figure_at_position(0, 1)
      expect(result).to eq(nil)
    end
  end

  describe '#team_figures' do
    let(:enemy_figure) { double('pawn', { direction: -1 }) }
    let(:enemy_field) { double('figure', { occupying: enemy_figure }) }
    let(:own_pawn) { double('pawn', { direction: 1 }) }
    let(:own_field) { double('figure', { occupying: own_pawn }) }

    before do
      allow(board).to receive(:fields).and_return([[empty_field, empty_field, enemy_field, enemy_field, empty_field],
                                                   [empty_field, empty_field, own_field, empty_field, empty_field],
                                                   [empty_field, own_field, own_field, own_field, empty_field],
                                                   [empty_field, empty_field, own_field, empty_field, empty_field],
                                                   [empty_field, empty_field, empty_field, empty_field, empty_field]])
    end
    context 'when asking for own fields ' do
      it 'returns team figures' do
        figures = board.team_figures(1)
        expect(figures).to eq([own_pawn, own_pawn, own_pawn, own_pawn, own_pawn])
      end
    end

    context 'when asking for enemy fields' do
      it 'returns enemy figures' do
        figures = board.team_figures(-1)
        expect(figures).to eq([enemy_figure, enemy_figure])
      end
    end
  end

  describe '#team_king' do
    let(:own_king) { double('own_king', { direction: 1 }) }
    let(:own_king_figure) { double('own_king_field', { occupying: own_king }) }
    let(:enemy_king) { double('enemy_king', { direction: -1 }) }
    let(:enemy_king_figure) { double('enemy_king_field', { occupying: enemy_king }) }

    before do
      allow(board).to receive(:fields).and_return([[own_king_figure, enemy_king_figure, empty_field]])
      allow(own_king).to receive(:is_a?).with(King).and_return(true)
      allow(enemy_king).to receive(:is_a?).with(King).and_return(true)
    end

    context 'when asking for own king' do
      it 'returns own king' do
        king = board.team_king(1)
        expect(king).to eq(own_king)
      end
    end

    context 'when asking for enemy king' do
      it 'returns enemy king' do
        king = board.team_king(-1)
        expect(king).to eq(enemy_king)
      end
    end
  end
end
