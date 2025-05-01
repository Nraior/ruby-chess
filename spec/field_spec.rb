require './lib/ruby_chess/field'

describe Field do
  subject(:field) { described_class.new(0, 0) }
  let(:figure) { double('figure') }
  describe '#occupy' do
    it('occupies field with selected figure') do
      field.occupy(figure)
      figure_occupying = field.occupying
      expect(figure_occupying).to eq(figure)
    end
  end

  describe '#free' do
    before do
      field.occupy(figure)
    end

    it('frees up space of feld') do
      expect { field.free }.to change { field.occupying }.to(nil)
    end
  end
end
