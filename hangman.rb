class Hangman
  attr_accessor :guessed_words, :guess, :secret_word

  def initialize
    @dictionary = File.readlines('dictionary.csv')
    @usable_words = []
    @guessed_words = []
    @dictionary.each do |word|
      @usable_words.push(word) if word.length > 4 && word.length < 13
    end
    @secret_word = @usable_words.sample.chomp
    @blank = @secret_word.split('')
    @word = @blank.dup
  end

  def blank
    puts "\n"
    @blank = @word.map do |letter|
      if !@guessed_words.include?(letter)
        letter = '_ '
      else "#{letter} "
      end
    end
    @blank = @blank.join('')
    print @blank
  end

  def player_guess
    loop do
    blank
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
    return if check_win == true
  end
end

  def guess_letter
    @guessed_words.push(@guess)
    blank
    puts "\n\n\n #{@secret_word}"
  end

  def check_win
    if !@blank.include?('_')
      puts 'you win'
      return true
    end
  end

end



game = Hangman.new
game.player_guess
