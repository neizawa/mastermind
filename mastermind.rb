require 'pry-byebug'

COLORS = ['red', 'green', 'blue', 'yellow', 'orange', 'violet']

module Display
  def display_colors
    puts "Available colors: #{COLORS.join(', ')}"
  end

  def display_feedback
    puts "#{@black_pegs} colors are correct in both color and position."
    puts "#{@white_pegs} colors are correct in color but wrong in position"
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
  attr_accessor :secret_colors, :black_pegs, :white_pegs, :rounds

  def initialize
    @secret_colors = []
    @black_pegs = 0
    @white_pegs = 0
    @rounds = 0
  end

  def play
    @secret_colors = Computer.choose_colors

    until @black_pegs == 4 || rounds > 12
      @black_pegs = 0
      @white_pegs = 0

      display_colors
      print 'Type 4 colors with space between them: '
      check_guess(input_guess)
      display_feedback
      @rounds += 1
    end
    @black_pegs == 4 ? display_victory : display_defeat
  end

  def input_guess
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
    %w[red green red yellow]
  end
end

def start_game
  puts 'Welcome to Mastermind.'
  game = Game.new
  game.play
end

start_game
