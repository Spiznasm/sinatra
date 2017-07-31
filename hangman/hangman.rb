require 'sinatra'

class Game
  require "json"
  
  #attr_accessor :guess, :wrong_guesses, :guessed_letters, :incorrect_letters, :secret_word
  def initialize
    #puts "Choose\n1. New Game\n2. Load Game\n3. Exit"
    #choice = gets.chomp.to_i
    reset
    # case choice
    # when 1
    #   reset
    #   play_game
    # when 2
    #   load_game
    #   play_game
    # when 3
    #   exit
    # else
    #   puts "Invalid choice"
    #   Game.new
    # end
  end

  def reset
    @wrong_guesses = 6
    @guessed_letters = []
    @incorrect_letters = []
    @secret_word = ""
    @guess = nil
    @picture_shift = 0
    set_word
  end


  def set_word
    until @secret_word.length.between?(5,12)
      @secret_word = File.readlines("5desk.txt").sample.strip
    end
  end

  def display_status
    @secret_word.split("").each {|letter| print @guessed_letters.include?(letter.downcase) ? letter + " " : "_" + " "}
    puts "You have #{@wrong_guesses} wrong guesses remaining.\nIncorrect guesses: #{@incorrect_letters.join " "}"
  end

  def get_guess
    puts "Guess a letter or type 'save' to save game."
    guess = gets.chomp
    case
    when guess.length > 1
      if guess == "save"
        self.save_game
      else
        puts "Guess a single letter"
        self.get_guess
      end
    when @guessed_letters.include?(guess)
      puts "That letter has already been guessed"
      self.get_guess
    else
      @guess = guess.downcase
      @guessed_letters.push(@guess)
    end
  end

  def check_win
    @secret_word.split("").all? {|letter| @guessed_letters.include?(letter)}
  end

  def check_guess
    if !(@secret_word.downcase.include?(@guess))
      @wrong_guesses -= 1
      @incorrect_letters.push(@guess)
      @picture_shift -= 75
      puts "That letter is not in the word"
    else
      puts "That letter is in the word"
    end
  end

  def serialize
    {"wrong_guesses" => @wrong_guesses,
    "guessed_letters" => @guessed_letters,
    "incorrect_letters" => @incorrect_letters,
    "secret_word"=>@secret_word}.to_json
  end

  def save_game
    puts "Name your save"
    save_name = gets.chomp
    File.open("saves/#{save_name}","w") {|save| save.write(serialize)}
    puts "Game Saved"
    exit
  end

  def load_game
    saved_games = Dir["saves/*"]
    if saved_games.empty?
      puts "No saved games found."
      exit
    end
    saved_games.each_with_index {|save,idx| puts "#{idx+1}. #{save[6..-1]}"}
    loop do
      print "What save number?"
      choice = gets.chomp.to_i
      if choice.between?(1,saved_games.length)
        JSON.load(File.open(saved_games[choice - 1],'r').read).each do |var,val|
          self.instance_variable_set '@'+var,val
        end
        break
      end
    end
  end


  def play_game

    until @wrong_guesses == 0 || self.check_win == true
      self.display_status
      self.get_guess
      self.check_guess
    end
    if @wrong_guesses == 0
      puts "Sorry you failed to guess #{@secret_word}"
    else
      puts "Congratulations you have successfully guessed #{@secret_word}"
    end
  end
end

get '/' do
  erb :index
end