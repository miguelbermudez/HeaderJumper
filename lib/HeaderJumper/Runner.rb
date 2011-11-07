require_relative 'Parse'
require_relative 'HeaderHtmlPage'

module HeaderJumper
  class Runner

    #attr_accessor :objs_to_parse, :parsed_objs
    attr_accessor :all_keywords

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
        htmlFile  = "#{obj.filename}.html"
        #htmlFileForKeywords = "#{obj.filename}_keyword.html"
        headerPage = HeaderHtmlPage.new(obj)
        headerPage.savePage(htmlFile);
        @all_keywords += obj.keywords
        @html_pages << headerPage
      end #parsed_objs.each
      
      #2nd pass for keywords
      @html_pages.each do |htmlpage|
        htmlFile  = "#{htmlpage.filename}.html"
        htmlFileForKeywords = "#{htmlpage.filename}_keyword.html"
        htmlpage.keywordPass(htmlFileForKeywords, @all_keywords)
      end
      
    end #run
  end #class
end #module
