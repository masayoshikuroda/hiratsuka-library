require 'date'
require 'json'
require_relative 'library'

#p ARGV
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
  print list.count{|book| book['limit'].to_date - Date.today < 0}.to_s + '件が貸出期限を過ぎています。'
#  list.each do |book|
#    print book['no'] + '件目、'
#    print book['title'] + '、の貸出期限は'
#    limit = book['limit'];
  #    diff = limit.to_date - Date.today
#    print diff.to_i.to_s + '日後です。'
#  end
end
print '"}'
