# coding: utf-8

require File.dirname(__FILE__) + '/lib/validator.rb'

puts "\n"
puts "Enter credit card number:"
puts "\n"


while input = STDIN.gets do
  #
  # Allow exiting the app more nicely than via control-c
  #
  break if ["exit", "end", ""].include?(input.chomp)
    
  valid = Validator.valid_number?(input) ? "valid" : "invalid"
  type = Validator.card_type(input)
  number = Validator.normalise_number(input)
  
  puts "#{type}: #{number} (#{valid})"
end