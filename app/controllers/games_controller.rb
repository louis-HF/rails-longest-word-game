require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (1..10).to_a.map { |letter| ("A".."Z").to_a[rand(1..24)] }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def score
    @letters = params[:letters].tr('\", \"','').tr('"[','').tr(']"','').split("")
    @word = params[:word].upcase.split("")
    @k = 0
    @word.each do |letter|
      if @letters.include?(letter)
        @letters.delete_at(@letters.index(letter))
      else
        @k += 1
      end
    end
    if @k > 0
      @result = "The word can't be built out of the original grid"
      @emoji = "🙄"
    elsif english_word?(@word.join())
      @result = "The word is valid according to the grid and is an English word"
      @emoji = "😁"
    else
      @result = "The word is valid according to the grid, but is not a valid English word"
      @emoji = "🙄"
    end
  end

end
