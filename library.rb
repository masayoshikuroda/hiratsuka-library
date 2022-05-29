require 'date'
require 'mechanize'
require 'open-uri'
require 'nokogiri'

class Library
  BASE_URL = 'https://www.lib.city.hiratsuka.kanagawa.jp/'

  def initialize
    @agent = Mechanize.new
  end

  def search(keyword)
    page = @agent.get(BASE_URL + 'index')
    form = page.forms[1]
    form.field_with(:name => 'textSearchWord').value = keyword
    button = form.button_with(name: 'buttonSubmit') 
    form.submit(button)
    #p '=== Search ==='

    page = @agent.page
    hit = page.search("//form/div[@class='number']/dl/dd/strong")[0].text
    #p hit

    books = getBooks()
    
    page = @agent.get(BASE_URL + 'idcheck')
    return books
  end

  def best_request
    page = @agent.get(BASE_URL + 'bestorderresult')
    #p '=== Best Request ==='

    books = getBooks()
    
    page = @agent.get(BASE_URL + 'idcheck')
    return books
  end

  def login(uid, pass)
    page = @agent.get(BASE_URL + 'idcheck')
    form = page.forms[2]
    form.field_with(:name => 'textUserId').value = uid
    form.field_with(:name => 'textPassword').value = pass
    button = form.button_with(name: 'buttonLogin') 
    form.submit(button)
    #p '=== Login ==='

    page = @agent.page
    message = page.search("//div[@class='mainBox']/section[1]/p/span").text.strip
    dts = page.search("//section[@class='topMenuBox']/dl/dt")
    borrowed = dts[0].text.strip.sub('件', '')
    reserved = dts[1].text.strip.sub('件', '')
    return message, borrowed, reserved
  end

  def logout
    page = @agent.page
    href = page.search("//li[@class='log_in']/a/@href").text
    link = page.link_with(:href => href);
    link.click
    #p '=== Logout ==='
  end

  def reserved
    page = @agent.page
    link = page.link_with(:href => './reservelist')
    link.click

    books = getBooks()
    
    page = @agent.get(BASE_URL + 'idcheck')
    return books
  end

  def borrowed
    page = @agent.page
    link = page.link_with(:href => './rentallist')
    link.click

    books = getBooks()

    page = @agent.get(BASE_URL + 'idcheck')
    return books
  end

  def getBooks
    page = @agent.page
    tables = page.search("//section[@class='infotable']")
    books = []
    tables.each{|table|
      book = {}
      book['no'] = table.search("h3/span[@class='num']").text
      book['title'] = table.search("h3/a/span").text
      dls = table.search("div[@class='tablecell']/div[@class='item']/dl")
      dls.each{|dl|
        dt = dl.search("dt").text.strip
        dd = dl.search("dd").text.strip
        book[toKey(dt)] = dd
      }
      if not book.include?('author') then
        book['author'] = '不明'
      end
      books.push book
    }
    return books
  end

  def toKey(dt)
    return case dt
    when '資料の種類' then 'type'
    when '出版年月'   then 'published_at'
    when '著者名'     then 'author'
    when '出版社'     then 'publisher'
    when '貸出場所'    then 'basyo'
    when '貸出日'     then 'borrowed_at'
    when '延長'      then 'encho'
    when '返却期限'   then 'limit_at'
    when '受取場所'   then 'basy'
    when '予約日'     then 'reserved_at'
    when '予約状況'    then 'status'
    when '予約件数'    then 'order'
    when '順位'      then 'order'
    else 'unknown'
    end
  end

  def toDate(value)
    value = value.sub(/年/, '/')
    value = value.sub(/月/, '/')
    value = value.sub(/日/, '')
    return Date.parse(value)
  end
end

if __FILE__ == $0
  if ARGV.size != 2 then
    puts "Usage: $ ruby #{$0} UID PASS"
    return
  end

  lib = Library.new
  lib.login(ARGV[1], ARGV[2])
  puts "Lonined!"
  lib.logout
  puts "Logout!"
end
