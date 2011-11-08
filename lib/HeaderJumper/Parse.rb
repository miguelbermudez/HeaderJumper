require "rubygems"
  
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
        code  =  IO.readlines(@filename)
        code.each_with_index do |line, index|
          if comment_matcher.match(line) and !comment_filter.match(line) 
            if has_code
              save_section(docs_text, code_text)
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

            #if line.match(Regexp.new('^class'))
            #if line.match(Regexp.new('^class\s+\w+|<(\w+)>'))
            #if line.match(/^class\s+([[:word:]]+)/) || line.match(/<([[:word:]]+)/)
            if line.match(/^class\s+([[:word:]]+)/)
              keyword = $1
              @keywords.push(keyword) if @keywords.include?(keyword) == false
              #puts @keywords.inspect #debugging
            end

            code_text += line + "\n"
            #code_text += line
          end
        end
      end
    end
      
   
    def save_section(docs, code)
      aSection = Section.new(docs, code)
      @sections << aSection        
    end
       
      

  end