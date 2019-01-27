require 'date'
require 'json'
require_relative 'library'

lib = Library.new
list = lib.best_request

print '{'
print '  "books": ['
list.each_with_index do |book, i|
  print JSON.pretty_generate(book)
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
    print '著者名は、'   + book['author'] + '、'
    print '出版年は'    + book['published_at'] + '、'
    print '予約件数は'   + book['order'] + '。'
  end
end
puts '"}'