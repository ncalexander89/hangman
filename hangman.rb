class Hangman
  attr_reader :secret_word

  def initialize
    @dictionary = File.readlines('dictionary.csv')
    @usable_words = []
    @dictionary.each do |word|
      @usable_words.push(word) if word.length > 4 && word.length < 13
    end
    puts @secret_word = @usable_words.sample
    @empty = '_ '
    puts "\n\n"
    @secret_word.length.times {print @empty}
  end

  def player_guess
    loop do
      puts "\n\nPick a letter or guess the word!"
      @guess = gets.chomp
      if @guess.length == 1
        guess_letter
        break
      elsif @guess.length != 1
        guess_word
        break
      end
    end
  end

  def guess_letter
    puts @secret_word
  end
end

game = Hangman.new
game.player_guess
