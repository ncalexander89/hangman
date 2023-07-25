require "yaml"

class Hangman
  #getter/setter method allows you to access instance variables using game.guess etc. Defined as read/write variables
  attr_accessor :guess, :guessed_letters, :secret_word, :turn, :blank, :word

#what are the initial conditions?
  def initialize
    @guessed_letters = []
    @turn = 1
  end

  def game_words
    @dictionary = File.readlines('dictionary.csv')
    @usable_words = []
    @dictionary.each do |word|
      @usable_words.push(word) if word.length > 4 && word.length < 13
    end
  end

  def hangman_word
    @secret_word = @usable_words.sample.chomp #removes trailing while line \n
    @blank = @secret_word.split('') #splits secret word into array of letters
    @word = @blank.dup #creates shallow copy of the @blank array, changes to @word will not affect @blank
  end

  def player_guess
    blank #shows number of letters in word
    puts "\n #{secret_word} \n"
    (11 - @turn).times do
      puts "\n Turn: #{@turn}/10"
      loop do
        save_option
        if @guess.length == 1 && @guess!='$'
          if @guessed_letters.include?(@guess)
            puts "\nLetter already chosen!"
            next #skips rest of loop, goes back to 'Pick letter'
          end
          guess_letter
          return if check_win
          @turn += 1
          break
        elsif @guess.length != 1
          return if guess_word #immediately halts method if True
          @turn += 1
          break #breaks loop counts as one turn in times loop
        end
        puts "\n Turn: #{@turn}/10"
      end
    end
    puts "\nYou lose the word was '#{secret_word}'\n\n"
  end

  def get_letters_only
    input = gets.chomp.downcase
    while input!=input.gsub(/[^A-Za-z$]/, '')
      puts 'Please enter alphabetical letters only'
      input = gets.chomp.downcase
    end
    return input
  end

  # Convert the Hangman object to a YAML format string using Class Method
  def self.save_game(filename, game_instance) #class method which saves the game instance into filename
    yaml_data = {
      secret_word: game_instance.secret_word,
      guessed_letters: game_instance.guessed_letters,
      turn: game_instance.turn,
      blank: game_instance.blank,
      word: game_instance.word
    }.to_yaml #method provided by yaml module similar to yaml.dump

    #opens file of filename and writes yaml_data to file
    File.open(filename, 'w') do |file|
      file.write(yaml_data)
    end
  end



#converting to YAML using instance method
=begin
  def to_yaml
    YAML.dump({ #similar to to_yaml
      secret_word: @secret_word,
      guessed_letters: @guessed_letters,
      turn: @turn,
      blank: @blank,
      word: @word
    })
  end
=end

=begin
Both of these methods need to be class methods because they deal with the process of creating new instances of the Hangman class
 based on data from YAML. 
 They don't operate on any specific instance of the class but rather handle the class-level logic for loading 
 and restoring Hangman games. Therefore, they are defined as class methods to provide functionality related to the class itself,
  not individual objects.
=end
  # Load the Hangman game from a file using YAML deserialization class method
  def self.load_game(filename)
    yaml_string = File.read(filename)
    from_yaml(yaml_string)
  end

  # Restore the Hangman object from a YAML format string class method
  def self.from_yaml(yaml_string)
    data = YAML.load(yaml_string)
    game = Hangman.new
    game.secret_word = data[:secret_word]
    game.guessed_letters = data[:guessed_letters]
    game.turn = data[:turn]
    game.blank = data[:blank]
    game.word = data[:word]
    game
  end

  def save_option
    puts "\nEnter $ to save game otherwise...\n"
    puts "\nPick a letter or guess the word!\n"
    @guess=get_letters_only
    if @guess=='$'
      Hangman.save_game('saved_game.yaml', self) #calls class method save_game 
      puts "\nGame Saved\n"
    end
  end

=begin
  def save_game(filename)
    File.open(filename, 'w') do |file| #do / end is used to define a block
      file.write(to_yaml)
    end
  end
=end

  def blank
    #puts "#{@word}"
    puts "\n"
    @blank = @word.map do |letter|
      if !@guessed_letters.include?(letter)
        '_ '
      else "#{letter} "
      end
    end
    @blank = @blank.join('')
    puts "#{@blank} \n"
  end

  def guess_letter
    puts "\n\nGuessed letters: #{@guessed_letters.push(@guess)}"
    blank
    puts "\n\n\n #{@secret_word}\n\n\n"
  end

  def check_win
    unless @blank.include?('_')
      puts "\nCongrats you guessed the word '#{@secret_word}!'\n\n"
      true #returns True
    end
  end

  def guess_word
    if @guess == @secret_word
      puts "\nCongrats you guessed the word '#{@secret_word}!'\n\n"
      true #returns True
    else puts "\nIncorrect guess!\n"
    end
  end
end

puts 'Welcome to Hangman!'
puts 'Load previous game Y/N?'
load_input = gets.chomp.downcase
until load_input=='y' || load_input=='n'
  puts 'Please enter Y or N'
  load_input = gets.chomp.downcase
end

if load_input=='y'
  game = Hangman.load_game('saved_game.yaml')
  #puts "secret word is #{game.secret_word}"
  game.game_words
  game.player_guess
else
  # Start a new game
  game = Hangman.new
  game.game_words
  game.hangman_word
  game.player_guess
end

=begin
When you load data from a YAML file, you typically don't have an object yet, so you use a class method to create a new object and populate it with the data from the YAML file. 
Once the object is created, you can then use its instance methods to interact with its data and behavior. 
This separation of responsibilities between class methods and instance methods allows for more flexible and organized code in YAML serialization and deserialization processes.
=end
