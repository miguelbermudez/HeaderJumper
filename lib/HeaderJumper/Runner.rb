require_relative 'Parse'
require_relative 'HeaderHtmlPage'
require_relative "PotionKeywordMaster"

module HeaderJumper
  class Runner

    #attr_accessor :objs_to_parse, :parsed_obj
    
    #Global list of all keywords found

    TEMP_FILE_PATH = "#{Dir.pwd}/tmp/"
    KEY_FILE_PATH = "#{Dir.pwd}/html/"

    def initialize(argv)
      @files_to_parse = Array.new
      @parsed_objs = Array.new
      @html_pages = Array.new
      @master_list_ref = PotionKeywordMaster.instance

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
        parsed_file = Parse.new(file, @master_list_ref)
        @parsed_objs << parsed_file
      end
      
      @parsed_objs.each do |obj|
        just_filename = obj.filename.split('/').last;
        htmlFile  = "#{TEMP_FILE_PATH}#{just_filename}.html"
        
        headerPage = HeaderHtmlPage.new(obj)
        headerPage.savePage(htmlFile);        
        @html_pages << headerPage
        
      end #parsed_objs.each
      
      #Sort master keywords list and html pages
      @master_list_ref.sort
      @html_pages.sort! { |x,y| y.title.length <=> x.title.length }
  
      puts "\n\t\tBEGIN 2ND PASS ON HTML FILES ..."
      #2nd pass for keywords
      @html_pages.each do |htmlpage|
        just_filename = htmlpage.filename.split('/').last
                
        html_to_read = "#{TEMP_FILE_PATH}#{just_filename}"
        html_to_save = "#{KEY_FILE_PATH}#{just_filename}"
        
        #htmlpage.keywordPass(html_to_read, html_to_save, @all_keywords)
        htmlpage.keywordPass(html_to_read, html_to_save)
      end
      
    end #run
  end #class
end #module
