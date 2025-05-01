require './lib/ruby_chess/board'
require './lib/ruby_chess/field'

describe Board do
  subject(:board) { described_class.new(8, 8) }
  let(:field) { double('field') }
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
end
