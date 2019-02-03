
require 'json'
require_relative 'library'

lib = Library.new
message, borrowed, reserved = lib.login(ARGV[0], ARGV[1])
list = lib.reserved
lib.logout

prepare = list.select{|book| book['status'] == '用意できています'}.length.to_s
print '{'
print '  "books": ['
list.each_with_index do |book, i|
  puts JSON.generate(book)
  print ',' if i != list.length - 1
end
print '],'
print '  "message": "'
if list.length == 0 then
  print '予約された資料はありません。'
else
  print reserved + '件の予約資料があります。'
  print prepare + '件が用意できています。'
end
puts '"}'
