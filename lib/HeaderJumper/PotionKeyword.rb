class PotionKeyword
  
  attr_accessor :origin, :is_multi_class_member
  attr_reader :word
  
  def initialize(word)
    @word = word
    @htmlID = "#{word}_id"
    @origin = ""
    @is_multi_class_member = false  
  end
  
  def to_s
  #  "Keyword: #{@word}, Origin: #{origin}, isMultiClass: #{@is_multi_class_member}"
  "Keyword: #{@word}"
  end
  
  
end 