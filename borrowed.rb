require 'date'
require 'json'
require_relative 'library'

lib = Library.new
lib.login(ARGV[0], ARGV[1])
list = lib.borrowed
lib.logout

puts '{'
puts '  "borrowed": ['
list.each_with_index do |book, i|
  puts JSON.pretty_generate(book)
  puts ',' if i != list.length - 1
end
puts '],'
print '  "message": "'
if list.length == 0 then
  print '貸出された資料はありません。'
else
  print list.length.to_s  + '件の貸出中の資料があります。'
  list.each do |book|
    print book['no'] + '件目、'
    print book['title'] + '、の貸出期限は'
    limit = book['limit'];
    year = limit.slice(0, 4).to_i
    month = limit.split('年')[1].split('月')[0].to_i
    day = limit.split('月')[1].split('日')[0].to_i
    diff = Date.new(year, month, day) - Date.today
    print diff.to_i.to_s + '日後です。'
  end
end
print '"}'
