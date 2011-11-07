require "rubygems"
require "erb"
require "nokogiri"
require "CGI"

class HeaderHtmlPage

  include ERB::Util
  attr_accessor :filename
  
  def initialize(parsed_obj, date=Time.now)
    @date = date
    @parsed_obj = parsed_obj
    @filename = "#{parsed_obj.filename}.html"
    @template = @parsed_obj.layout
    @title = @parsed_obj.filename.split('/').last
    #@keywords = @parsed_obj.keywords
    puts "FILE: #{@parsed_obj.filename}"
    puts "\tKEYWORDS: #{@parsed_obj.keywords.inspect}"
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def savePage(file)
    #puts "FILE TO SAVE: #{file}"
    File.open(file, "w+") do |f|
      f.write(render)
    end
  end
  
    
  def keywordPass(kw, all_keywords)
      #puts "KEYWORD FILE TO SAVE: #{k2}"
      f = File.open(@filename, "r")
      doc = Nokogiri::HTML(f)
      f.close
      
      #@parsed_obj.keywords.each do |keyword|
      all_keywords.each do |keyword|
        classLink = '<a class="keyword" href="' + keyword + '.h_keyword.html">' + keyword + "<\/a>"   
        #get each pre node
        doc.xpath('//pre').each do |node|
          #empty string to hold sub'd html lines
          replacementString = ""
          #grab its text
          text = node.content
  
          #loop through each line of text
          text.each_line do |ln|
            ln.sub!(Regexp.new(keyword), classLink)
            replacementString += ln
          end #text.each
          
          #replace the node's text with our new text
          node.content = replacementString if replacementString.length > 0
        end #doc.xpath
      end #keywords.eac

    #save new file
    File.open(kw, 'w') { |kf| kf.write(CGI.unescapeHTML(doc.to_html))}
  end #keywordPass
end
