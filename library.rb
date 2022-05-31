require 'json'
require 'selenium-webdriver'

class Library
  BASE_URL = 'https://www.lib.city.hiratsuka.kanagawa.jp/'

  def initialize
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      'goog:chromeOptions' => {
        'args' => ['headless'],
      },
    )
    options = Selenium::WebDriver::Chrome::Options.new
    options.headless!
    @driver = Selenium::WebDriver.for :chrome, options: options
    @driver.manage.timeouts.implicit_wait = 10
  end

  def login(uid, pass)
    @driver.navigate.to BASE_URL + 'idcheck'
    form = @driver.find_element(:xpath, "//form[@id='inputForm49']")
    form.find_element(:name, 'textUserId').send_keys(uid)
    form.find_element(:name, 'textPassword').send_keys(pass)
    form.find_element(:name, "buttonLogin").click

    anker = @driver.find_element(:xpath, '//li[@class="nav02"]/a')
    anker.click
    
    mainBox = @driver.find_element(:xpath, "//div[@class='mainBox']")
    message = mainBox.find_element(:xpath, "section[1]/p/span").text.strip
    borrowed = mainBox.find_element(:xpath, "section/section[1]/dl/dt").text.strip.sub('件', '')
    reserved = mainBox.find_element(:xpath, "section/section[2]/dl/dt").text.strip.sub('件', '')
    return message, borrowed, reserved
  end

  def logout
    anchor = @driver.find_element(:xpath, "//li[@class='log_in']/a")
    anchor.click
  end

  def reserved
    anchor = @driver.find_element(:xpath, '//dd[@class="linkBtn"]/a[@href="./reservelist"]')
    anchor.click

    books = getBooks()
    
    anchor = @driver.find_element(:xpath, '//li[@class="nav02"]/a')
    anchor.click

    return books
  end

  def borrowed
    anchor = @driver.find_element(:xpath, '//dd[@class="linkBtn"]/a[@href="./rentallist"]')
    anchor.click

    books = getBooks()
    
    anchor = @driver.find_element(:xpath, '//li[@class="nav02"]/a')
    anchor.click

    return books
  end

  def search(keyword)
    @driver.navigate.to BASE_URL + 'index'
    form = @driver.find_element(:xpath, '//section[@class="topSearch"]/form')
    form.find_element(:name, 'textSearchWord').send_keys(keyword)
    form.find_element(:name, "buttonSubmit").click

    hit = @driver.find_element(:xpath, '//form/div[@class="number"]/dl/dd/strong').text

    books = getBooks()
    
    return books
  end

  def best_request
    @driver.navigate.to BASE_URL + 'bestorderresult'

    books = getBooks()
    
    return books
  end

  def getBooks
    tables = @driver.find_elements(:xpath, '//section[@class="infotable"]')
    books = []
    tables.each{|table|
      book = {}
      book['no'] = table.find_element(:xpath, 'h3/span[@class="num"]').text
      book['title'] = table.find_element(:xpath, 'h3/a/span').text
      dls = table.find_elements(:xpath, 'div[@class="tablecell"]/div[@class="item"]/dl')
      dls.each{|dl|
        if dl.find_elements(:xpath, 'dt').size != 0 then
            dt = dl.find_element(:xpath, 'dt').text.strip
            dd = dl.find_element(:xpath, 'dd').text.strip
            book[toKey(dt)] = dd
        end
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
    exit
  end
  
  lib = Library.new
  m,b,r = lib.login(ARGV[0], ARGV[1])
  output = { "message" => m, "borrowed" => b, "reserved" => r}
  lib.logout
  puts JSON.generate(output)
end
