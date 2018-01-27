require 'mechanize'
require 'open-uri'
require 'nokogiri'

class String
  def to_date()
    year  = self.slice(0, 4).to_i
    month = self.split('年')[1].split('月')[0].to_i
    day   = self.split('月')[1].split('日')[0].to_i
    return Date.new(year, month, day)
  end	  
end

class Library
  BASE_URL = 'https://www.lib.city.hiratsuka.kanagawa.jp/'

  def initialize
    @agent = Mechanize.new
  end

  def search(keyword)
    page = @agent.get(BASE_URL + 'search2.html')
    form = page.form_with(:action => '/clis/search')
    form.field_with(:name => 'KEY1').value = keyword
    form.radiobuttons_with(:id => 'SORT5')[0].check
    form.submit
    #p '=== Search ==='
    books = []
    page = @agent.page
    html = Nokogiri::HTML(page.body)
    html.css('table tbody tr').each do |tr|
      book = {}
      book['no']        = tr.css('td')[0].text
      book['type']      = tr.css('td')[1].text
      book['title']     = tr.css('td')[2].text
      book['author']    = tr.css('td')[3].text
      book['publisher'] = tr.css('td')[4].text
      book['published'] = tr.css('td')[5].text
      book['lang']      = tr.css('td')[6].text
      books.push book
    end
    return books
  end
 
  def best_request
    page = @agent.get(BASE_URL + 'shiraberu_6.html')
    form = page.form_with(:action => '/clis/odrsearch')
    form.radiobuttons_with(:id => 'CATEGORY1')[0].check
    form.submit
    #p '=== Best Reuest ==
    books = []
    page = @agent.page
    html = Nokogiri::HTML(page.body)
    html.css('table tbody tr').each do |tr|
      book = {}
      book['no']        = tr.css('td')[0].text
      book['type']      = tr.css('td')[1].text
      book['title']     = tr.css('td')[2].text
      book['author']    = tr.css('td')[3].text
      book['publisher'] = tr.css('td')[4].text
      book['published'] = tr.css('td')[5].text
      book['ordered']   = tr.css('td')[6].text
      book['lang']      = tr.css('td')[7].text
      books.push book
    end
    return books
  end

  def login(uid, pass)
    page = @agent.get(BASE_URL + 'idcheck.html')
    form = page.form_with(:action => BASE_URL + 'clis/login')
    form.field_with(:name => 'UID').value = uid
    form.field_with(:name => 'PASS').value = pass
    form.submit
    #p '=== Login ==='
  end

  def logout
    page = @agent.page
    form = page.form_with(:action => BASE_URL + 'clis/logout')
    form.submit
    #p '=== Logout ==='
  end

  def reserved
    page = @agent.page
    link = page.link_with(:text => '予約状況照会へ')
    link.click
    books = []
    page = @agent.page
    html = Nokogiri::HTML(page.body)
    html.css('table tbody tr').each do |tr|
      book = {}
      book['no']     =  tr.css('td')[0].text
      book['kumi']   =  tr.css('td')[1].text
      book['title']  =  tr.css('td')[2].text
      book['basyo']  =  tr.css('td')[3].text
      book['limit']  =  tr.css('td')[4].text
      book['status'] =  tr.css('td')[5].text
      book['order']  =  tr.css('td')[6].text
      book['start']  =  tr.css('td')[7].text
      book['hatena'] =  tr.css('td')[8].text
      book['encho']  =  tr.css('td')[9].text
      books.push book
    end
    link = page.link_with(:text => 'メニューへ戻る')
    link.click
    return books
  end

  def borrowed
    page = @agent.page
    link = page.link_with(:text => '貸出状況照会へ')
    link.click
    books = []
    page = @agent.page
    html = Nokogiri::HTML(page.body)
    html.css('table tbody tr').each do |tr|
      book = {}
      book['no']     =  tr.css('td')[0].text
      book['title']  =  tr.css('td')[1].text
      book['basyo']  =  tr.css('td')[1].text
      book['start']  =  tr.css('td')[3].text
      book['limit']  =  tr.css('td')[4].text
      book['owner']  =  tr.css('td')[6].text
      books.push book
    end
    link = page.link_with(:text => 'メニューへ戻る')
    link.click
    return books
  end
end
