# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

class Game
  def initialize
    @board = Board.new
    puts 'Enter Player 1 name:'
    p1 = gets.chomp
    puts 'Enter Player 2 name:'
    p2 = gets.chomp
    @player1 = Player.new(p1, 'X')
    @player2 = Player.new(p2, 'O')
    @current_player = @player1
  end

  def switch_player
    @current_player = if @current_player == @player1
                        @player2
                      else
                        @player1
                      end
  end

  def play
    loop do
      @board.display

      puts "#{@current_player.name}, choose position:"
      pos = gets.chomp.to_i

      if @board.valid_move?(pos)
        @board.update(pos, @current_player.symbol)
        if winner?(@current_player.symbol)
          @board.display
          puts "#{@current_player.name} wins!"
          break
        end

        if draw?
          @board.display
          puts 'Game is a draw!'
          break
        end

        switch_player

      else
        puts 'Invalid move!'
      end
      
    end
  end

  def winner?(symbol)
    win_patterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ]
    win_patterns.any? do |pattern|
      pattern.all? { |i| @board.cells[i] == symbol }
    end
  end

  def draw?
    @board.cells.none? { |cell| cell.is_a?(Integer) }
  end
end
