class Hangman
  attr_accessor :guessed_words, :guess, :secret_word

  def initialize
    @dictionary = File.readlines('dictionary.csv')
    @usable_words = []
    @guessed_letters = []
    @turn = 1
    @dictionary.each do |word|
      @usable_words.push(word) if word.length > 4 && word.length < 13
    end
    @secret_word = @usable_words.sample.chomp
    @blank = @secret_word.split('')
    @word = @blank.dup
    blank
  end

  def player_guess
    10.times do
      puts "\n Turn: #{@turn}/10"
      loop do
        puts "\nPick a letter or guess the word!\n"
        @guess = gets.chomp.downcase
        if @guess.length == 1
          guess_letter
          @turn += 1
          break
        elsif @guess.length != 1
          guess_word
          @turn += 1
          return
        end
      end
      return if check_win == true || guess_word == true
    end
    puts "\nYou lose the word was '#{secret_word}'\n\n"
  end

  private

  def blank
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
    # puts "\n\n\n #{@secret_word}\n\n\n"
  end

  def check_win
    unless @blank.include?('_')
      puts "\ncongrats you guessed the word '#{@secret_word}'\n\n"
      true
    end
  end

  def guess_word
    if @guess == @secret_word
      puts "\ncongrats you guessed the word '#{@secret_word}'\n\n"
      true
    end
  end
end

game = Hangman.new
game.player_guess
