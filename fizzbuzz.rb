# frozen_string_literal: true

class FizzBuzz
  @n = 0
  class << self
    attr_accessor :fizz_count, :buzz_count

    FizzBuzz.fizz_count = 0
    FizzBuzz.buzz_count = 0
  end

  def initialize(number)
    puts self.class.fizz_count
    puts self.class.buzz_count
    @n = number
  end

  def self.reset_count
    FizzBuzz.fizz_count = 0
    FizzBuzz.buzz_count = 0
  end

  def print_fizz_count
    puts self.class.fizz_count
  end

  def print_buzz_count
    puts self.class.buzz_count
  end

  def fizz
    puts :fizz
    self.class.fizz_count = self.class.fizz_count + 1
  end

  def buzz
    puts :buzz
    self.class.buzz_count = self.class.buzz_count + 1
  end

  def fizzbuzz
    puts :fizzbuzz
    self.class.fizz_count = self.class.fizz_count + 1
    self.class.buzz_count = self.class.buzz_count + 1
  end

  def determine_fuzziness(number)
    if (number % 15).zero?
      fizzbuzz
    elsif (number % 3).zero?
      fizz
    elsif (number % 5).zero?
      buzz
    else
      puts number
    end
  end

  def play
    1.upto(@n) do |i|
      determine_fuzziness(i)
    end
  end
end
