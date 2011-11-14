require "rubygems"
require "erb"
require "nokogiri"
require "CGI"

class HeaderHtmlPage

  include ERB::Util
  attr_reader :filename
  
  def initialize(parsed_obj, date=Time.now)
    @date = date
    @parsed_obj = parsed_obj
    @filename = "#{parsed_obj.filename}.html"
    @template = @parsed_obj.layout
    @title = @parsed_obj.filename.split('/').last
    @all_keywords = Array.new
    
    puts "FILE: #{@parsed_obj.filename}"
    puts "\tKEYWORDS: #{@parsed_obj.keywords.inspect}"
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def savePage(file)
    puts "\t\t1ST PASS - FILE TO SAVE: #{file}" #set full path filename
    File.open(file, "w+") do |f|
      f.write(render)
    end
  end
  
    
  def keywordPass(html_to_open, html_to_save, all_keywords)
      #puts "\t\tALL KEYWORDS: #{all_keywords}"
      puts "\t\t\t+ HTML FILE TO OPEN: #{html_to_open}"
      puts "\t\t\t\t- KEYWORD_HTML TO SAVE: #{html_to_save}\n"
      f = File.open(html_to_open, "r")
      doc = Nokogiri::HTML(f)
      f.close
      
      all_keywords.each do |keyword|
        classLink = '<a class="keyword" href="' + keyword + '.h.html">' + keyword + "<\/a>"   
        #puts "\t\tKEYWORD LINK: #{classLink}" #debugging
        
        #populate index
        div_index = doc.xpath('//*[@id="index"]/ul')
  
        
        keyword_li = Nokogiri::XML::Node.new "li", doc
        
        keyword_link = Nokogiri::XML::Node.new "a", doc
        keyword_link['href'] = "#{keyword}.h.html"
        keyword_link.content = "#{keyword}.h"

        keyword_link.parent = keyword_li
        
        div_index.at_css('ul').add_child(keyword_li)
        
        #get each pre node
        doc.xpath('//pre').each do |node|
          #empty string to hold sub'd html lines
          replacementString = ""
          #grab its text
          text = node.content
  
          #loop through each line of text
          text.each_line do |ln|
            
            keywordRegex = Regexp.new('\b'+keyword+'\b');
            ln.sub!(keywordRegex, classLink)
            replacementString += ln
          end #text.each
          
          #replace the node's text with our new text
          node.content = replacementString if replacementString.length > 0
        end #doc.xpath
      end #keywords.eac

    #save new file
    File.open(html_to_save, 'w') { |kf| kf.write(CGI.unescapeHTML(doc.to_html))}
  end #keywordPass
end
