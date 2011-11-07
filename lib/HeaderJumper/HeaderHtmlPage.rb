require "rubygems"
require "erb"
require "nokogiri"

class HeaderHtmlPage

  include ERB::Util

  def initialize(parsed_obj, date=Time.now)
    @date = date
    @parsed_obj = parsed_obj
    @template = @parsed_obj.layout
    @title = @parsed_obj.filename.split('/').last
    #@sections = @parsed_obj.sections
    @keywords = @parsed_obj.keywords
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def savePage(file)
    puts "FILE TO SAVE: #{file}"
    File.open(file, "w+") do |f|
      f.write(render)
    end
  end

  def keywordPass(file)
    puts "KEYWORD FILE TO SAVE: #{file}"
    f = File.open(file)
    doc = Nokogiri::HTML(f)
    f.close
  end

end
