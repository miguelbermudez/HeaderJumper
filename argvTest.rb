#get the folder containing images
folder      = ARGV[0]
#get the output_filename
output_name = ARGV[1]
#get the extensions you want
extension   = ARGV[2]

p "folder: #{folder} 1:#{output_name}  2:#{extension}" 
puts "\tUsing argv: #{ARGV}"

#get the images in the folder
files = Dir.glob("#{folder}/}") do |f|
  p f #debugging
end

ARGV.each do |f|
  puts File.file?(f)
end

if File.file?(ARGV)
 puts "yea"
end
