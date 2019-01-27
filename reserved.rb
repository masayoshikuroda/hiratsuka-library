
require 'json'
require_relative 'library'

lib = Library.new
borrowed, reserved = lib.login(ARGV[0], ARGV[1])
list = lib.reserved
lib.logout

puts '{'
puts '  "books": ['
list.each_with_index do |book, i|
  puts JSON.pretty_generate(book)
  puts ',' if i != list.length - 1
end
puts '],'
puts '  "message": "'
if list.length == 0 then
  puts '予約された資料はありません。'
else
  puts reserved + '件の予約資料があります。最初の' + list.length.to_s  + '件の資料です。'
  list.each_with_index do |book, i|
    if i > 1 then
      break
    end
    print book['no'] + '件目、'
    print book['title'] + '。'
    puts
  end
end
puts '"}'
