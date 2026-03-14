# frozen_string_literal: true

class Board
  attr_reader :cells

  def initialize
    @cells = (1..9).to_a
  end

  def display
    puts "#{@cells[0]} | #{@cells[1]} | #{@cells[2]}"
    puts '---------'
    puts "#{@cells[3]} | #{@cells[4]} | #{@cells[5]}"
    puts '---------'
    puts "#{@cells[6]} | #{@cells[7]} | #{@cells[8]}"
  end

  def update(position, symbol)
    @cells[position - 1] = symbol
  end

  def valid_move?(position)
    @cells[position - 1].is_a?(Integer)
  end
end
