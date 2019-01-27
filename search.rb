require 'date'
require 'json'
require_relative 'library'

#p ARGV
if ARGV.size < 1 then
  puts "Usage: ruby #{$0} keyword"
  exit
end

lib = Library.new
list = lib.search(ARGV[0])

puts '{'
puts '  "search": ['
list.each_with_index do |book, i|
  puts JSON.pretty_generate(book)
  puts ',' if i != list.length - 1
end
puts '],'
print '  "message": "'
if list.length == 0 then
  print '該当データはみつかりませんでした。'
else
  puts list.length.to_s  + '件の資料がみつかりました。'
  list.each_with_index do |book, i|
    if i > 1 then
      break
    end
    print book['no'] + '件目、'
    print 'タイトルは、' + book['title'] + '、'
    print '著者名は、'  + book['author'] + '、'
    print '出版年は'    + book['published_at'] + '。'
    puts
  end
end
print '"}'