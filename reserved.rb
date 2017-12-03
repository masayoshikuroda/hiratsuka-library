
require_relative 'library'

lib = Library.new
lib.login(ARGV[0], ARGV[1])
list = lib.reserved
lib.logout

puts '{'
puts '  "reserved": '; p list
puts '  "message": '
if list.length == 0 then
  puts '予約された資料はありません。'
else
  puts list.length.to_s  + '件の予約資料があります。'
  list.each do |book|
    puts book['no'] + '件目、'
    puts book['title'] + '、'
    puts book['status'] + '。'
  end
end
puts '}'
