require "rubygems"
require "erb"
require "nokogiri"
require "CGI"
require_relative "PotionKeywordMaster"

class HeaderHtmlPage

  include ERB::Util
  attr_reader :filename, :title
  
  def initialize(parsed_obj, date=Time.now)
    @date = date
    @parsed_obj = parsed_obj
    @filename = "#{parsed_obj.filename}.html"
    @template = @parsed_obj.layout
    @title = @parsed_obj.filename.split('/').last
    @master_list_ref = @parsed_obj.master_list_ref
  
    #puts "FILE: #{@parsed_obj.filename}"
    #puts "\tKEYWORDS: #{@parsed_obj.keywords.inspect}"
    #puts "\tKEYWORDS: #{@parsed_obj.master_list_ref.inspect}"
  end

  def render()
    #@master_list_ref.print_keywords
    ERB.new(@template).result(binding)
  end

  def savePage(file)
    puts "\t\t1ST PASS - FILE TO SAVE: #{file}" #set full path filename
    @master_list_ref.sort
    File.open(file, "w+") do |f|
      f.write(render)
    end
  end
  
  def keywordPass(html_to_open, html_to_save)
      #puts "\t\tALL KEYWORDS: #{@master_list_ref.keywords.inspect}"
      puts "\t\t\t+ HTML FILE TO OPEN: #{html_to_open}"
      puts "\t\t\t\t- KEYWORD_HTML TO SAVE: #{html_to_save}\n"
      #@master_list_ref.print_keywords

      all_keywords = @master_list_ref.keywords
      #@master_list_ref.print_keywords

      f = File.open(html_to_open, "r")
      doc = Nokogiri::HTML(f)
      f.close
      all_keywords.each do |keyword|
        #puts keyword.inspect
        #populate index
        #div_index = doc.xpath('//*[@id="index"]/ul')
        
        #keyword_li = Nokogiri::XML::Node.new "li", doc
        #keyword_link = Nokogiri::XML::Node.new "a", doc
        
        #keyword_link['href'] = "#{keyword.origin}.html"
        #keyword_link.content = "#{keyword.word}
        fullPath = File.dirname(html_to_open) + "/" + keyword.word + ".h.html"
        
        if File.file?(fullPath) == false
        #  puts fullPath
        #  puts "false: #{keyword.word}"
          classLink = '<a class="keyword" href="' + keyword.origin + '.html">' + keyword.word + "<\/a>"   
        else 
          classLink = '<a class="keyword" href="' + keyword.word + '.h.html">' + keyword.word + "<\/a>"   
        end
        #keyword_link.content = "#{keyword.word}.h"
        #keyword_link.parent = keyword_li
        #div_index.at_css('ul').add_child(keyword_li)
        
        #get each pre node
        doc.xpath('//pre').each do |node|
          #empty string to hold sub'd html lines
          replacementString = ""
          #grab its text
          text = node.content
  
          #loop through each line of text
          text.each_line do |ln|
            #keywordRegex = Regexp.new('(?<!")'+keyword.word)
            #keywordRegex = Regexp.new('\b'+keyword.word+'\b')
            keywordRegex = Regexp.new('(?<!href=")'+keyword.word+'\b')
            #keywordRegex = Regexp.new('\s+'+"#{keyword.word}")
            if ln.match(keywordRegex)
              #puts "\n#{@filename}:\t#{ln}"
              ln.sub!(keywordRegex, classLink)
              #puts "\t\t#{ln}"
              # => sleep 1 # debugging
            end
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
