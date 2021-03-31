# frozen_string_literal: true

require_relative 'fizzbuzz'

puts :fizzerbuzzer
fizzerbuzzer = FizzBuzz.new(76)

fizzerbuzzer.play
fizzerbuzzer.print_fizz_count
fizzerbuzzer.print_buzz_count

puts :buzzerfizzer
buzzerfizzer = FizzBuzz.new(32)

buzzerfizzer.play
buzzerfizzer.print_fizz_count
buzzerfizzer.print_buzz_count

FizzBuzz.reset_count

puts :reset
buzzerfizzer.print_fizz_count
buzzerfizzer.print_buzz_count
