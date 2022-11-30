# frozen_string_literal: true

class GameBoard
  attr_accessor :board, :win_combos

  def initialize
    @board = [1, 2, 3,
              4, 5, 6,
              7, 8, 9]
    @win_combos = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]] # indexes
  end

  def print_board
    p board[0..2].join(' ')
    p board[3..5].join(' ')
    p board[6..8].join(' ')
    puts "\n"
  end

  def win_check
    win = false
    (0..win_combos.length - 1).each do |i|
      case board.values_at(win_combos[i][0], win_combos[i][1], win_combos[i][2])
      when %w[x x x]
        puts 'X wins!'
        win = true
      when %w[y y y]
        puts 'Y wins!'
        win = true
      end
    end
    win
  end

  def full_board_check
    check = board.none? { |i| i.is_a?(Integer) }
    puts 'TIE (board is full!)' if check == true
    check
  end

  def space_taken?(move)
    return unless (board[move - 1] == 'x') || (board[move - 1] == 'y')

    puts 'Space taken, try again'
    true
  end

  def record_move(move, symbol)
    board[move - 1] = symbol
    print_board
  end

  def game_over?
    return true if full_board_check || win_check
  end
end

class Player
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def verify_move(move)
    move.is_a?(Integer) && move.positive? && move < 10
  end

  def make_move(game_board)
    move = 0
    until verify_move(move) && !game_board.space_taken?(move)
      loop do
        puts 'Choose space (1-9)'
        move = gets.to_i
        break
      end
    end
    move
  end
end

class Game
  attr_reader :game_board, :player_x, :player_y

  def initialize
    @game_board = GameBoard.new
    @player_x = Player.new('x')
    @player_y = Player.new('y')
  end

  def playing
    loop do
      puts 'Player X:'
      move = player_x.make_move(game_board)
      game_board.record_move(move, player_x.symbol)
      break if game_board.game_over?

      puts 'Player Y:'
      move = player_y.make_move(game_board)
      game_board.record_move(move, player_y.symbol)
      break if game_board.game_over?
    end
  end

  def instructions
    puts 'Welcome to the game'
    game_board.print_board
  end

  def play_game
    instructions
    loop do
      game = Game.new
      game.playing
      break if new_game_check == 'n'
    end
  end

  def new_game_check
    puts 'Play again? (y/n)'
    newgame = ''
    newgame = gets.chomp until %w[y n].include?(newgame)
    newgame
  end
end

# Game.new.play_game
