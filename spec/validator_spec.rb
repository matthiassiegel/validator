# coding: utf-8

require "spec_helper"


describe "Validator" do
  
  describe "#valid_number?" do
    
    it "should return true for any number that passes the Luhn verification and has a known credit card format" do
      Validator.valid_number?(4111111111111111).should be_true
      Validator.valid_number?('4012888888881881').should be_true
      Validator.valid_number?(378282246310005).should be_true
      Validator.valid_number?(5105105105105100).should be_true
    end
    
    it "should return false for numbers that fail the Luhn verification" do
      Validator.valid_number?(3).should be_false
      Validator.valid_number?(372).should be_false
      Validator.valid_number?(37283).should be_false
    end
    
    it "should return false for numbers that pass the Luhn verification but don't have a known credit card format" do
      Validator.valid_number?(0).should be_false
      Validator.valid_number?(37283).should be_false
      Validator.valid_number?(3728375).should be_false
    end
  end
  
  
  describe "#card_type" do
    
    it "should return 'AMEX' if number has 15 digits and begins with either 34 or 37" do
      Validator.card_type('12345 67890 12345').should eq("Unknown")
      Validator.card_type('34345 67890 12345').should eq("AMEX")
      Validator.card_type(373456789012345).should eq("AMEX")
      Validator.card_type('37345 67890 12345234').should eq("Unknown")
    end
    
    it "should return 'Discover' if number has 16 digits and begins with 6011" do
      Validator.card_type('60115 67890 123456').should eq("Discover")
      Validator.card_type('60115a67890%123456').should eq("Discover")
      Validator.card_type(60111567890123456).should eq("Unknown")
    end
    
    it "should return 'Visa' if number has either 13 or 16 digits and begins with 4" do
      Validator.card_type(4234567890123).should eq("VISA")
      Validator.card_type('4234567890123456').should eq("VISA")
      Validator.card_type('42345678901234567').should eq("Unknown")
      Validator.card_type('3234567890123456').should eq("Unknown")
    end
    
    it "should return 'MasterCard' if number has 16 digits and begins with 51, 52, 53, 54 or 55" do
      Validator.card_type(5134567890123456).should eq("MasterCard")
      Validator.card_type('523 4567890123456').should eq("MasterCard")
      Validator.card_type('5334567890123456').should eq("MasterCard")
      Validator.card_type(5434567890123456).should eq("MasterCard")
      Validator.card_type(5534567890123456).should eq("MasterCard")
      Validator.card_type('562345 67890 12345').should eq("Unknown")
      Validator.card_type('502345 67890 12345').should eq("Unknown")
    end
  end
  
  
  describe "#normalise_number" do
    
    it "should remove linebreaks" do
      Validator.normalise_number("24323423\n4234234234\n").should eq(243234234234234234)
    end
    
    it "should remove spaces" do
      Validator.normalise_number("24323423 4234 234234").should eq(243234234234234234)
    end
    
    it "should filter out any non-numeric characters" do
      Validator.normalise_number("24$3c2F34&UU2+=]3 _4.234 23 4LLeü234").should eq(243234234234234234)
    end
    
    it "should convert string inputs to integer" do
      Validator.normalise_number("243234234234234234").should eq(243234234234234234)
    end
  end
      
end