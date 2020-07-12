# hiratsuka-library

平塚図書館の情報を取得します。

## Required library

- ruby
 - mechanize
 - nokogiri


## Usage
```
$ ruby reserved.rb UID PASS
{ "reserved": [{"no": "1", "title": "xxx" ..., "status": "予約中です"}, {...},...]}
$ ruby borrowed.rb UID PASS
{ "borrowed": [{"no": "1", "title": "xxx" ..., "limit", "2017年1月1日"}, {...},...]}
$ ruby best_request.rb
{ "best_request": [{"no": "1", "title": "xxx" ..., "ordered": "192" }, {...},...]}
$ ruby search.rb KEYWORD
{ "search": [{"no": "1", "title": "xxx" ...}, {...},...]}
```
