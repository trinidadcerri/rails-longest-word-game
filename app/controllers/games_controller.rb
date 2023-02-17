require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @the_message = nil
    input = params[:new]
    @letters = params[:letters]
    check_for_letters = included?(input,@letters)
    if check_for_letters
      if english_word_exists?(input) # The word is valid according to the grid and is an English word (2 conditions)
        @the_message = "Congratulations! #{input} is a valid English word!"
      else # The word is valid according to the grid, but is not a valid English word
        @the_message = "Sorry but #{input} does not seem to be a valid English word..."
      end
    else
      @the_message = "Sorry but #{input} can't be built out of #{@letters}"
    end
    p english_word_exists?(input)
  end

  private

  def english_word_exists?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json["found"]
  end

  def included?(word,letters)
    word&.chars&.uniq&.all? { |char| letters.include?(char) }
  end
end
