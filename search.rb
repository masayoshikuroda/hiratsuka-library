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

print '{'
print '  "books": ['
list.each_with_index do |book, i|
  print JSON.generate(book)
  print ',' if i != list.length - 1
end
print '],'
print '  "message": "'
if list.length == 0 then
  print '該当データはみつかりませんでした。'
else
  print list.length.to_s  + '件の資料がみつかりました。'
  list.each_with_index do |book, i|
    if i > 1 then
      break
    end
    print book['no'] + '件目、'
    print 'タイトルは、' + book['title'] + '、'
    print '著者名は、'  + book['author'] + '、'
    print '出版年は'    + book['published_at'] + '。'
  end
end
puts '"}'