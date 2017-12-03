require 'json'
require_relative 'library'

lib = Library.new
lib.login(ARGV[0], ARGV[1])
list = lib.reserved
lib.logout

puts '{'
puts '  "reserved": ['
list.each_with_index do |book, i|
  puts JSON.pretty_generate(book)
  puts ',' if i != list.length - 1
end
puts '],'
print '  "message": "'
if list.length == 0 then
  print '予約された資料はありません。'
else
  print list.length.to_s  + '件の予約資料があります。'
  list.each do |book|
    print book['no'] + '件目、'
    print book['title'] + '、'
    print book['status'] + '。'
  end
end
print '"}'
