require './lib/tictactoe'

describe GameBoard do
  context 'When GameBoard is initialized' do
    describe '#initialize' do
      subject(:new_game) { described_class.new }
      it 'has 9 spaces' do
        expect(new_game.board.length).to eq(9)
      end
      it 'Update space' do
        new_game.board[1] = 'y'
        expect(new_game.board[1]).to eq('y')
      end
    end
  end
  
  describe '#win_check' do
    context 'When a player wins' do
      subject(:win_game) { described_class.new }
      context 'If player is x' do
        before do
          win_game.board = ['x', 'x', 'x', 4, 5, 6, 7, 8, 9]
        end
        it 'returns true' do
          expect(win_game.win_check).to be true
        end
        it 'prints the correct message for x' do
          expect(win_game).to receive(:puts).with('X wins!').once
          win_game.win_check
        end
      end
      context 'If player is y' do
        before do
          win_game.board = ['y', 2, 3, 'y', 5, 6, 'y', 8, 9]
        end
        it 'returns true' do
          expect(win_game.win_check).to be true
        end
        it 'prints the correct message for y' do
          expect(win_game).to receive(:puts).with('Y wins!').once
          win_game.win_check
        end
      end

      it 'results in game over' do
        allow(win_game).to receive(:win_check).and_return(true)
        expect(win_game).to be_game_over
      end
    end

    context 'When a player does not win' do
      subject(:continue_game) { described_class.new }
      it 'returns false' do
        expect(continue_game.win_check).to be false
      end
      it 'does not result in game over' do
        allow(continue_game).to receive(:win_check).and_return(false)
        expect(continue_game).not_to be_game_over
      end
    end

  end

  describe '#space_taken?' do
    subject(:game_taken) { described_class.new }
    context 'When space is taken' do  
      it 'Shows error message' do
        move = 2
        game_taken.board[1] = 'y'
        expect(game_taken).to receive(:puts).with('Space taken, try again').once
        game_taken.space_taken?(move)
      end
      it 'Returns true' do
        move = 2
        game_taken.board[1] = 'y'
        check = game_taken.space_taken?(move)
        expect(check).to be true
      end
    end
    context 'When space is not taken' do
      it 'Does not show error message' do
        move = 2
        game_taken.board[1] = 2
        expect(game_taken).not_to receive(:puts).with('Space taken, try again')
        game_taken.space_taken?(move)
      end
      it 'returns nil' do
        move = 2
        game_taken.board[1] = 2
        check = game_taken.space_taken?(move)
        expect(check).to be nil
      end
    end
    
  end

  describe '#full_board_check' do
    context 'if board is full' do
      subject(:full_board) { described_class.new }
      before do
        full_board.board = ['x','x','y','y','x','x','y','x','y',]
      end
      it 'returns true' do
        expect(full_board.full_board_check).to be(true)
      end
      it 'prints message' do
        expect(full_board).to receive(:puts).with('TIE (board is full!)').once
        full_board.full_board_check
      end
    end
    context 'if board is not full' do
      subject(:not_full_board) { described_class.new }

      it 'returns false' do
        check = not_full_board.full_board_check
        expect(check).to be(false)
      end
      it 'does not print message' do
        expect(not_full_board).not_to receive(:puts).with('TIE (board is full!)')
        not_full_board.full_board_check
      end
    end
  end

  describe '#game_over?' do
    subject(:game_end) { described_class.new }

    context 'When board is full' do
      it 'is game over' do
        allow(game_end).to receive(:full_board_check).and_return(true)
        expect(game_end).to be_game_over
      end
    end

    context 'When a player wins' do
      it 'is game over' do
        allow(game_end).to receive(:win_check).and_return(true)
        expect(game_end).to be_game_over
      end
    end

    context 'When the board is not full and no players won' do
      it 'is not game over' do
        allow(game_end).to receive(:win_check).and_return(false)
        allow(game_end).to receive(:full_board_check).and_return(false)
        expect(game_end).not_to be_game_over
      end
    end
  end

  describe '#record_move' do
    subject(:moving) { described_class.new }
    context 'adds the symbol to the correct spot' do
      it 'Adds y to the 4th spot' do
        symbol = 'y'
        move = 4
        moving.record_move(move, symbol)
        expect(moving.board[3]).to eq('y')
      end
      it 'Adds x to the 9th spot' do
        symbol = 'x'
        move = 9
        moving.record_move(move, symbol)
        expect(moving.board[8]).to eq('x')
      end
    end
  end
end

describe Player do
  describe '#initialize' do
    context 'When player is initialized' do
      subject(:new_player) { described_class.new('y') }
      it 'assigns correct symbol' do
        expect(new_player.symbol).to eq('y')
      end
    end
  end
  describe '#verify_move' do
    subject(:verifymove) { described_class.new('x') }
    context 'When given valid input' do
      it 'returns true' do
        input = 1
        verify = verifymove.verify_move(input)
        expect(verify).to eq(true)
      end 
    end
    context 'When given invalid input' do
      it 'returns false' do
        input = 'a'
        verify = verifymove.verify_move(input)
        expect(verify).to eq(false)
      end
    end
    
  end
  describe '#make_move' do
    let(:game_board) { instance_double(GameBoard) }
    subject(:player_turn) { described_class.new('x') }

    context 'When move is valid' do
      before do
        allow(game_board).to receive(:space_taken?)
        allow(player_turn).to receive(:gets).and_return('4')
      end
      it 'returns move' do
        turn = player_turn.make_move(game_board)
        expect(turn).to eq(4)
      end
      it 'sends the move to GameBoard' do
        turn = player_turn.make_move(game_board)
        expect(game_board).to receive(:record_move).with(turn, player_turn.symbol).once
        game_board.record_move(turn, player_turn.symbol)
      end
    end
    context 'When move is invalid' do
      before do
        allow(game_board).to receive(:space_taken?)
        allow(player_turn).to receive(:gets).and_return('a', '444', 'hi', '7')
      end
      it 'continues looping until valid move is given' do
        expect(player_turn).to receive(:puts).exactly(4).times
        player_turn.make_move(game_board)
      end
    end
  end
end

describe Game do
  describe '#playing' do
    let(:board) { instance_double(GameBoard) }
    let(:x) { instance_double(Player) }
    subject(:new_game) { described_class.new }

    context 'When playing' do
      before do
        allow(x).to receive(:make_move).and_return(5)
        allow(board).to receive(:record_move)
      end
      it 'Gets the right move' do
        move = x.make_move(board)
        expect(move).to be(5)
      end
    end
  end
  
  describe '#new_game_check' do
    subject(:end_game) { described_class.new }
    context 'Valid input' do
      before do
        allow(end_game).to receive(:new_game_check).and_return('y')
      end
      it 'returns the correct input' do
        expect(end_game.new_game_check).to eq('y')
      end
      before do
        allow(end_game).to receive(:gets).and_return('y', 'x')
      end
      it 'Stops loop when correct' do
        expect(end_game.new_game_check).to eq('y')
      end
    end
    context('Invalid input') do
      before do
        allow(end_game).to receive(:gets).and_return('e', '5', 'n')
      end
      it 'loops until correct input' do
        expect(end_game.new_game_check).to eq('n')
      end
    end
  end
end