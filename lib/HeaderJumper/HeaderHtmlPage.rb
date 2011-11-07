require "rubygems"
require "erb"
require "nokogiri"

class HeaderHtmlPage
  
  include ERB::Util
  attr_accessor :template, :parsed_obj, :date
  
  def initialize(parsed_obj, date=Time.now)
    @date = date
    @parsed_obj = parsed_obj
    @template = @parsed_obj.layout
    @title = @parsed_obj.filename.split('/').last
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
  
  
end