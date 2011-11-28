require "singleton"

class PotionKeywordMaster
    include Singleton

    attr_accessor :keywords

    def initialize
        puts "Initializing @master_list..."
        @keywords = Array.new
    end



    def sort
        #sort keywords by length of work (longest first)
        #puts "\n*** SORTING ALL KEYWORDS: "+ @keywords.inspect + " ***"
        @keywords.sort! { |x,y| y.word.length <=> x.word.length }
        #puts "\t\tAfter Sort: #{@keywords.inspect}" #debugging
    end

    def contains_keyword(keyword)
        result = false
        #puts "\tcontains #{keyword}?" #debugging
        @keywords.each do |k|
            if k.word == keyword
                #puts "\t#{k}?...TRUE" #debugging
                result = true
            else
                #puts "\t#{k}?...FALSE" #debugging
            end
        end
        #puts "\t\tkeywords: #{@keywords.inspect}" #debugging
        return result
    end

    def print_keywords
        puts "\t\tALL KEYWORDS: "
        @keywords.each {|k| puts "\t\t\t#{k}"}
    end
end