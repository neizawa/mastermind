COLORS = %w[red green blue yellow orange violet]

module Display
  def display_colors
    puts "Available colors: #{COLORS.join(', ')}"
  end

  def display_feedback
    puts "\n#{@black_pegs} colors are correct in both color and position."
    puts "#{@white_pegs} colors are correct in color but wrong in position.\n\n"
  end

  def display_guess(guess)
    puts "Computer's guess: #{guess.join(' ')}"
  end

  def display_secret_colors(colors)
    puts "Secret colors: #{colors.join(' ')}"
  end

  def display_victory
    puts 'Congratulations! You won!'
  end

  def display_defeat
    puts 'Game over! You lost.'
  end
end

class Game
  include Display
  attr_accessor :secret_colors, :black_pegs, :white_pegs, :turns

  def initialize
    @secret_colors = []
    @black_pegs = 0
    @white_pegs = 0
    @turns = 0
  end

  def choose_role
    case gets.chomp.downcase
    when 'codebreaker'
      play_codebreaker
    when 'codemaker'
      play_codemaker
    else
      print 'Invalid choice. Choose whether "Codebreaker" or "Codemaker": '
      choose_role
    end
  end

  def play_codebreaker
    @secret_colors = 4.times.map { COLORS.sample }

    until @black_pegs == 4 || turns > 12
      human_turn
    end

    @black_pegs == 4 ? display_victory : display_defeat
    display_secret_colors(@secret_colors)
  end

  def play_codemaker
    print 'Type 4 colors with space between them: '
    @secret_colors = gets.chomp.split(' ')

    until @black_pegs == 4 || turns > 12
      computer_turn
    end

    @black_pegs == 4 ? display_defeat : display_victory
    display_secret_colors(@secret_colors)
  end

  def human_turn
    @black_pegs = 0
    @white_pegs = 0

    display_colors
    print 'Type 4 colors with space between them: '
    guess = human_guess
    check_guess(guess)
    display_feedback
    @turns += 1
  end

  def computer_turn
    @black_pegs = 0
    @white_pegs = 0

    guess = computer_guess
    display_guess(guess)
    check_guess(guess)
    display_feedback
    @turns += 1
  end

  def computer_guess
    4.times.map { COLORS.sample }
  end

  def human_guess
    guess = gets.chomp.split(' ')
    correct_colors = guess.reduce(0) do |memo, string|
      COLORS.any?(string) ? memo += 1 : memo -= 999
      memo
    end

    return guess if correct_colors == 4

    print 'Invalid colors. Try again: '
    human_guess
  end

  def check_guess(guess)
    temp_colors = []
    temp_guess = []
    temp_colors += @secret_colors
    temp_guess += guess

    check_black_pegs(temp_guess, temp_colors)
    check_white_pegs(temp_guess, temp_colors)
  end

  def check_black_pegs(guess, colors)
    guess.each_index do |index|
      next unless guess[index] == colors[index]

      @black_pegs += 1
      colors[index] = nil
      guess[index] = nil
    end
  end

  def check_white_pegs(guess, colors)
    guess.each_index do |index|
      next unless (colors.include? guess[index]) && !guess[index].nil?

      colors[index] = nil
      @white_pegs += 1
    end
  end
end

def start_game
  game = Game.new
  print 'Do you want to play as "Codebreaker" or "Codemaker"? '
  game.choose_role
  restart_game?
end

def restart_game?
  print 'Do you want to restart game? '
  gets.chomp.downcase == 'yes' ? start_game : puts('Thank you for playing!')
end

print 'Welcome to Mastermind. '
start_game
