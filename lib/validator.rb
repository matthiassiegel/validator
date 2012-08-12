# coding: utf-8

class Validator
  
  #
  # Check if a credit card number is valid, by verifying it with the Luhn algorithm and checking for known credit card formats
  #
  # @param [String, Integer] input Credit card number
  # @return [Boolean] True if number is a valid credit card number, false otherwise
  #
  def self.valid_number?(input)
    number = normalise_number(input).to_s
    even = false
    sum = 0
    
    #
    # Luhn: starting with the last digit, add each digit to sum, but for every other digit, double it, 
    # and if that results in a 2-digit number, just add the sum of these 2 digits ((n * 2) - 9)
    #
    for n in number.reverse.scan(/./) do
      n = n.to_i
      sum += (even = !even) ? n : (n < 5 ? n * 2 : (n * 2) - 9)
    end
    
    #
    # If the Luhn sum is a multiple of 10, and #card_type recognises the format, the credit card number appears to be valid
    #
    sum % 10 == 0 && card_type(input) != "Unknown"
  end
  
  #
  # Determine credit card type
  #
  # @param [String, Integer] input Credit card number
  # @return [Boolean] True if number is a valid credit card number, false otherwise
  #
  def self.card_type(input)
    number = normalise_number(input)
    
    type = "Unknown"
    
    case number.to_s.length
      when 13
        type = "VISA" if number.to_s[0] == "4"
      
      when 15
        type = "AMEX" if ['34', '37'].include?(number.to_s[0..1])
      
      when 16
        if number.to_s[0] == "4"
          type = "VISA"
        
        elsif number.to_s[0..3] == "6011"
          type = "Discover"
          
        elsif (51..55).to_a.include?(number.to_s[0..1].to_i)
          type = "MasterCard"
        end
    end
    
    type
  end
  
  
  #
  # Remove spaces and linebreaks and other non-numeric characterss from a supplied credit card number
  #
  # @param [String, Integer] input Credit card number
  # @return [Integer] Supplied credit card number with all non-numeric characterss removed
  #
  def self.normalise_number(number)
    number.to_s.chomp.gsub(/[^0-9]/, '').to_i
  end
  
end