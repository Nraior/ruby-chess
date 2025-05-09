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
end
