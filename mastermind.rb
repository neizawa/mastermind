require 'pry-byebug'

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
    case gets.chomp
    when 'Codebreaker'
      play_codebreaker
    when 'Codemaker'
      play_codemaker
    else
      print 'Invalid choice. Choose whether "Codebreaker" or "Codemaker": '
      choose_role
    end
  end

  def play_codebreaker
    @secret_colors = Computer.choose_colors

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
    check_guess(guess)
    display_feedback
    @turns += 1
  end

  def computer_turn
    @black_pegs = 0
    @white_pegs = 0

    computer_guess = Computer.guess
    check_guess(computer_guess)
    display_guess(computer_guess)
    display_feedback
    @turns += 1
  end

  def guess
    gets.chomp.split(' ')
  end

  def check_guess(guess)
    temp_colors = []
    temp_colors += @secret_colors

    temp_colors = check_black_pegs(guess, temp_colors)
    check_white_pegs(guess, temp_colors)
  end

  def check_black_pegs(guess, temp_colors)
    guess.each_index do |index|
      next unless guess[index] == temp_colors[index]

      @black_pegs += 1
      temp_colors[index] = nil
    end
    temp_colors
  end

  def check_white_pegs(guess, temp_colors)
    guess.each_index do |index|
      next unless temp_colors.include? guess[index]

      temp_colors.delete_at(temp_colors.index(guess[index]))
      @white_pegs += 1
    end
  end
end

class Computer
  def self.choose_colors
    4.times.map { COLORS.sample }
  end

  def self.guess
    4.times.map { COLORS.sample }
  end
end

def start_game
  game = Game.new
  print 'Welcome to Mastermind. Do you want to play as "Codebreaker" or "Codemaker"? '
  game.choose_role
  restart_game?
end

def restart_game?
  print 'Do you want to restart game? '
  gets.chomp.downcase == 'yes' || gets.chomp.downcase == 'y' ? start_game : puts('Thank you for playing!')
end

start_game
