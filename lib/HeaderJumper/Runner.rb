require_relative 'Parse'
require_relative 'HeaderHtmlPage'

module HeaderJumper
  class Runner

    #attr_accessor :objs_to_parse, :parsed_objs
    attr_accessor :all_keywords
    
    TEMP_FILE_PATH = "#{Dir.pwd}/tmp/"
    KEY_FILE_PATH = "#{Dir.pwd}/html/"

    def initialize(argv)
      @files_to_parse = Array.new
      @parsed_objs = Array.new
      @html_pages = Array.new
      @all_keywords = Array.new

      #check if what's given is a file or directory
      argv.each do |file|
        if File.file?(file)
          @files_to_parse << file
        else
          #list of files to parse from directory
          @files_to_parse = Dir.glob("#{argv}/*")
        end
      end
    end
    

    def run
      @files_to_parse.each do |file|
        parsed_file = Parse.new(file)
        @parsed_objs << parsed_file
      end
      
      @parsed_objs.each do |obj|
        just_filename = obj.filename.split('/').last;
        #htmlFile  = "#{TEMP_FILE_PATH}#{obj.filename}.html"
        htmlFile  = "#{TEMP_FILE_PATH}#{just_filename}.html"
        headerPage = HeaderHtmlPage.new(obj)
        headerPage.savePage(htmlFile);
        
        #only add keywords if they are not already accountanted for 
        obj.keywords.each do |obj_keyword|
          if @all_keywords.include?(obj_keyword) == false
            #puts "\t\tAdding keyword: #{obj_keyword}"
            @all_keywords << obj_keyword
          end
          #@all_keywords += obj.keywords
        end
        
        @html_pages << headerPage
      end #parsed_objs.each
      
      #sort keywords by length of work (longest first)
      @all_keywords.sort! { |x,y| y.length <=> x.length }
      puts "\n\n*** SORTING ALL KEYWORDS: "+@all_keywords.inspect + " *** "
      
      
      puts "\t\tBEGIN 2ND PASS ON HTML FILES ..."
      #2nd pass for keywords
      @html_pages.each do |htmlpage|
        just_filename = htmlpage.filename.split('/').last
                
        html_to_read = "#{TEMP_FILE_PATH}#{just_filename}"
        html_to_save = "#{KEY_FILE_PATH}#{just_filename}"
        
        htmlpage.keywordPass(html_to_read, html_to_save, @all_keywords)
      end
      
    end #run
  end #class
end #module
