# frozen_string_literal: true

class FizzBuzz
  @n = 0
  class << self
    attr_accessor :fizz_count, :buzz_count

    FizzBuzz.fizz_count = 0
    FizzBuzz.buzz_count = 0
  end

  def initialize(number)
    @n = number
  end

  def self.reset_count
    FizzBuzz.fizz_count = 0
    FizzBuzz.buzz_count = 0
  end

  def print_fizz_count
    puts FizzBuzz.fizz_count
  end

  def print_buzz_count
    puts FizzBuzz.buzz_count
  end

  def fizz
    puts :fizz
    FizzBuzz.fizz_count += 1
  end

  def buzz
    puts :buzz
    FizzBuzz.buzz_count += 1
  end

  def fizzbuzz
    puts :fizzbuzz
    FizzBuzz.fizz_count += 1
    FizzBuzz.buzz_count += 1
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
