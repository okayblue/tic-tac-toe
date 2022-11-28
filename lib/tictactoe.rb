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
    for i in 0..win_combos.length - 1
      if board.values_at(win_combos[i][0], win_combos[i][1], win_combos[i][2]) == %w[x x x]
        puts 'X wins!'
        win = true
      elsif board.values_at(win_combos[i][0], win_combos[i][1], win_combos[i][2]) == %w[y y y]
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
end

class Player
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def make_move(game_board)
    move = 0
    until move.positive? && move < 10
      loop do
        puts 'choose space (1-9)'
        move = gets.to_i
        # check if space is taken
        next if game_board.board[move - 1] == 'x' or game_board.board[move - 1] == 'y'

        break
      end
    end
    game_board.board[move - 1] = symbol
    game_board.print_board
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
    puts 'Welcome to the game'
    game_board.print_board

    loop do
      puts 'Player X:'
      player_x.make_move(game_board)
      game_board.win_check
      break if game_board.win_check == true
      break if game_board.full_board_check == true

      puts 'Player Y:'
      player_y.make_move(game_board)
      break if game_board.win_check == true

      break if game_board.full_board_check == true
    end
  end

  def new_game_check
    puts 'Play again? (y/n)'
    newgame = ''
    newgame = gets.chomp until %w[y n].include?(newgame)
    newgame
  end
end

# loop do
#   game = Game.new
#   game.playing
#   next if game.new_game_check == 'y'

#   break
# end
