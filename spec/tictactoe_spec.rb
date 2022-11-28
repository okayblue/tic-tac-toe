require './lib/tictactoe'

describe GameBoard do
  context 'When GameBoard is initialized' do
    describe '#initialize' do
      subject(:new_game) { described_class.new }
      it 'has 9 spaces' do
        expect(new_game.board.length).to eq(9)
      end
    end

  end
end