
require_relative 'library'

lib = Library.new
borrowed, reserved = lib.login(ARGV[0], ARGV[1])
list = lib.borrowed
lib.logout

puts '{'
puts '  "borrowed": '; p list
puts '  "message": "'
if list.length == 0 then
  puts '貸出された資料はありません。'
else
  puts borrowed + '件の貸出資料があります。'
  list.each_with_index do |book, i|
    if i > 1 then
      break
    end
    print book['no'] + '件目、'
    print 'タイトルは、' + book['title'] + '、'
    print '貸出期限は' + book['limit_at'] + '。'
    puts
  end
end
puts '"}'
