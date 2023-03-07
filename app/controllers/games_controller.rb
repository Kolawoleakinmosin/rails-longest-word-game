require 'open-uri'
require 'json'

# class for game.
class GamesController < ApplicationController
  def new
    @random_letters = random_letters
  end

  def score
    user_input = params[:guess].upcase
    @result = find_the_english_word(user_input)
    @score = calculate_score(user_input, @result)
  end

  def random_letters
    @letters = ('A'..'Z').to_a
    @random_letters = []

    10.times do
      @random_letters << @letters.sample
    end

    @random_letters
  end

  def find_the_english_word(input)
    english_word_url = "https://wagon-dictionary.herokuapp.com/#{input}"
    english_word_serialized = URI.open(english_word_url).read
    @is_english_word = JSON.parse(english_word_serialized)['found']
    @is_english_word && input.chars.all? { |letter| input.count(letter) <= @random_letters.count(letter) }
  end

  def calculate_score(input, is_english_word)
    if is_english_word
      input.length
    else
      0
    end
  end
end
