class Game

  public

  def initialize
    @guesses_left = 6
    @player_won = false
    @dictionary = File.readlines("5desk.txt")

    @dictionary.each do |word|
      word.upcase!
      word.gsub!(/\s*/, "")
    end

    @dictionary.select! do |word|
      word.length > 5 && word.length < 12
    end

    @answer_word = @dictionary[rand(@dictionary.length)].split("")
    @alphabet = *('a'..'z')
    @alphabet_guesses = []
    @secret_word = []
    @answer_word.length.times { @secret_word.push("_") }
  end

  def play_round
    puts " \nThe current word is #{@secret_word.join(' ')}"
    puts "What letter do you guess?"
    letter_guess = gets.chomp.upcase!
    index_to_swap = []
    temp_word = @answer_word.clone

    #Repeat letter guessed
    if @alphabet_guesses.any? { |letter| letter == letter_guess }
      puts "You already guessed that letter!"
      return
    end

    #Incorrect letter guessed
    unless temp_word.include?(letter_guess)
      @guesses_left -=1
      puts "\nSorry! #{letter_guess} isn't in the word. " \
           "You have #{@guesses_left} guesses left!"
      @alphabet_guesses.push(letter_guess)
      puts "Your current guesses are #{@alphabet_guesses.join(' ')}"
    end

    #Correct letter guessed
    while temp_word.include?(letter_guess)
      swap_index = temp_word.index(letter_guess)
      index_to_swap.push(swap_index)
      temp_word[swap_index] = "_"
      @alphabet_guesses.push(letter_guess)
    end

    index_to_swap.length.times do |i|
        @secret_word[index_to_swap[i]] = letter_guess
    end

    unless @secret_word.include?("_")
      @player_won = true
    end
  end

  def play_game
    while @guesses_left > 0 && @player_won == false
      play_round
    end

    ending = @player_won ? "Congrats, you won! The word was " \
                           "#{@answer_word.join}": \
                           "Sorry, the word was #{@answer_word.join} " \
                           "Try again next time."
    puts ending
  end


  private

end


game1 = Game.new
game1.play_game


