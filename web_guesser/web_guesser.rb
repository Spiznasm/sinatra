require 'sinatra'
require 'sinatra/reloader'

SECRET_NUMBER = rand(100)
def check_guess(number)
  if number.nil?
    ""
  elsif number.to_i-SECRET_NUMBER > 5
    "Way too high"
  elsif number.to_i-SECRET_NUMBER > 0
    "Too high"
  elsif number.to_i-SECRET_NUMBER == 0
    "YOU DID IT!\n The secret number is #{SECRET_NUMBER}."
  elsif number.to_i-SECRET_NUMBER < -5
    "Way too low"
  elsif number.to_i-SECRET_NUMBER < 0
    "Too low"
  end
end

get '/' do
  message = check_guess(params['guess'])
  erb :index, :locals => {:secret_number => SECRET_NUMBER, :message => message}
end