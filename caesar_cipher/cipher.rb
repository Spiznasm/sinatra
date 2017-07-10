require 'sinatra'
require 'sinatra/reloader'

def caesar_cipher(message,displacement)
  text = message.to_s
  shift = displacement.to_i
  
  letters = text.split("")
  letter_values = Hash.new
  #p letters
  ('a'..'z').zip(0..25).each do |pair|
    letter_values[pair[1]]=pair[0]
    letter_values[pair[0]]=pair[1]
  end
  

  shifted_string=""

  letters.each do |letter|
    #puts letter
    if letter.match(/[^a-zA-Z]/)
      shifted_string << letter

    elsif letter.match(/[A-Z]/)
      shifted_string << letter_values[(letter_values[letter.downcase]-shift)%26].upcase

    else
      shifted_string << letter_values[(letter_values[letter]-shift)%26]

    end
  end

  shifted_string
end

get '/' do
  coded_message = caesar_cipher(params['text'],params['shift'].to_i)
  erb :index, :locals => {:coded_message => coded_message}
end