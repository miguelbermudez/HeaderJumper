class PotionKeyword

  attr_accessor :origin
  attr_reader :word

  def initialize(word)
    @word = word
    @htmlID = "#{word}_id"
    @origin = ""
  end

  def to_s
    "Keyword: #{@word}, Origin: #{origin}"
  #"Keyword: #{@word}"
  #"#{@word}"
  end
end 