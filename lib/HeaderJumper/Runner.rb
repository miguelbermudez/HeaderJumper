require_relative 'Parse'
require_relative 'HeaderHtmlPage'

module HeaderJumper
  class Runner
        
    #attr_accessor :objs_to_parse, :parsed_objs

    def initialize(argv)
      @files_to_parse = Array.new
      @parsed_objs = Array.new
      
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
        #puts "obj.filename: #{obj.filename}" #debugging
        #puts "obj.layout: #{obj.layout}" #debugging
        headerPage = HeaderHtmlPage.new(obj)
        headerPage.savePage(obj.filename + ".html");
      end
            
    end
    
  end
  
end

