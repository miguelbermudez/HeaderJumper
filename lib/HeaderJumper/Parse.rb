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
    
    attr_accessor :template, :layout, :master_list_ref
    attr_reader :filename, :sections
    
    def initialize(filename, master_list)
      @filename = filename
      @sections = Array.new
      @layout = File.read(DEFAULT_LAYOUT)
      @master_list_ref = master_list
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
        #puts "FILE: #{@filename}" #debugging
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

            #remove whitespace
            line.gsub!(/$\s+/, "")
            line.gsub!(/^\s+/, "")

            line = line.gsub('\t', "").gsub('\n',"").gsub(/\s+1/,"")

            has_code = true
            code_text += line + "\n"
            #code_text += line
            
            if line.match(/(class|public|private)\s+((?!boost)\w+\s*)(\s+|;|:|\{)?/)
              keyword = $2
              thirdComponent = $3
              #remove all beginning and trailling whitespace
              keyword = keyword.gsub(/^\s+/, "").gsub(/\s+$/, "")

              pKeyword = PotionKeyword.new(keyword)
              pKeyword.origin = @filename.split('/').last
              #puts "\tChecking #{pKeyword.word}..." #debugging
              if @master_list_ref.contains_keyword(keyword) == false && thirdComponent != ";" && keyword.length > 1
                @master_list_ref.keywords << pKeyword 
                #puts "\tMatched Line: #{line}" #debugging
                #puts "\tAdded #{keyword} to the master list\n\n" #debugging
              end
            end
          end
        end

        save_section(docs_text, code_text)
      end
    end
      
   
    def save_section(docs, code)
      #puts "DOCS: #{docs}\n\tCODE: #{code}" #debugging
      aSection = Section.new(docs, code)
      @sections << aSection        
    end    

  end