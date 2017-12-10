require 'date'
require 'json'
require_relative 'library'

lib = Library.new
list = lib.best_request

puts '{'
puts '  "best_request": ['
list.each_with_index do |book, i|
  puts JSON.pretty_generate(book)
  puts ',' if i != list.length - 1
end
puts '],'
print '  "message": "'
if list.length == 0 then
  print '該当データはみつかりませんでした。'
else
  print list.length.to_s  + '件の資料がみつかりました。'
  list.each_with_index do |book, i|
    if i > 3 then
      break
    end
    print book['no'] + '件目、'
    print book['title'] + '、'
    print '著者名は、'
    print book['author'] + '、'
    print book['published'] + '年に出版。'
    print book['ordered'] + '件の予約があります。'
  end
end
print '"}'
