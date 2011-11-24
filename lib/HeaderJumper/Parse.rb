require "rubygems"
require_relative "PotionKeyword"
  
  class Section
    attr_accessor :docs, :code
    def initialize(docs, code)
      @docs = docs
      @code = code
    end
  end
  
  class Parse
    
    DEFAULT_LAYOUT = "./public/page.erb"
    
    attr_accessor :keywords, :template, :layout
    attr_reader :filename, :sections
    
    def initialize(filename)
      @filename = filename
      @sections = Array.new
      @keywords = Array.new
      @layout = File.read(DEFAULT_LAYOUT)

      parse_file(@filename)
    end
    
    #read entire file into an array of strings
    def parse_file(file)
      comment_symbol = "//"
      comment_matcher = Regexp.new('^\\s*' + comment_symbol + '\\s?')
      comment_filter = Regexp.new('(^#![/]|^\\s*#\\{)')

      docs_text = code_text = '';
      has_code = false
      
      if @filename
         #get file as one string for class detecting
         f = File.new(@filename)
         text = f.read
         f.close
        
        code  =  IO.readlines(@filename)
        code.each_with_index do |line, index|
          if comment_matcher.match(line) and !comment_filter.match(line) 
            if has_code
              save_section(docs_text, code_text)
              
              #reset docs and code
              docs_text = code_text = ''
              has_code = false
            end

            #docs_text += line.sub(comment_matcher, '') + "\n"
            docs_text += line.sub(comment_matcher, '')

          else
            #remove tabs
            #line.gsub!("\t", "")

            #remove newlines
            line.gsub!(/\n+/, "")

            #remove leading whitespace
            line.gsub!(/$\s+/, "")
            line.gsub!(/^\s+/, "")

            line = line.gsub('\t', "").gsub('\n',"").gsub(/\s+1/,"")

            has_code = true

            if line.match(/^class\s+([[:word:]]+)/)
              #puts "CLASS #: #{class_count}"
              
              keyword = $1
              pKeyword = PotionKeyword.new(keyword)
              pKeyword.origin = @filename.split('/').last
              pKeyword.is_multi_class_member = true if text.scan(/class/).length > 1
              
              #@keywords.push(pKeyword) if @keywords.include?(pKeyword.word) == false
              @keywords << pKeyword if contains_keyword(pKeyword.word) == false
              #puts @keywords.inspect + "\n" #debugging
            end

            code_text += line + "\n"
            #code_text += line
          end
          
          
        end
      end
    end
      
   
    def save_section(docs, code)
      #puts "DOCS: #{docs}\n\tCODE: #{code}" #debugging
      aSection = Section.new(docs, code)
      @sections << aSection        
    end
    
    def contains_keyword (keyword)
      @keywords.each do |k|
        if k.word == keyword
          return true
        end
      end
      return false
    end
    

  end