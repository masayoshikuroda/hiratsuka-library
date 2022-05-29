require 'json'
require_relative 'library'

if ARGV.size != 2 then
  puts "Usage: $ ruby #{$0} UID PASS"
  return
end

lib = Library.new
message, borrowed, reserved = lib.login(ARGV[0], ARGV[1])
list = lib.borrowed
lib.logout
over = list.select{|book| lib.toDate(book['limit_at']) < Date.today }.length.to_s

print '{'
print '  "books": ['
list.each_with_index do |book, i|
  print JSON.pretty_generate(book)
  print ',' if i != list.length - 1
end
print "], \"borrowed\": #{borrowed}, \"over\": #{over}, "
print '  "message": "'
if list.length == 0 then
  print '貸出された資料はありません。'
else
  print borrowed + '件の貸出資料があります。'
  print over + '件の貸出期限をすぎた資料があります。'
end
puts '"}'
