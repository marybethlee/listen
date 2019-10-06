## listen
send data to postgres and fire database triggers to a javascript socket to update the client.

Working example: 
http://listen-and-notify.herokuapp.com/

This is a sinatra application

## Mac Install instructions
```bash
brew intall postgresql;
brew services start postgresql;
psql
```
```
CREATE DATABASE listen_development;
\q
```
```bash
bundle install;
rackup # a port can be specified with rackup -p 4567
```

## It should work!!

This project uses rackup + config.ru file to run the program
<br/>ruby app.rb does not work because the app.rb file does not use run!
<br/>using rackup is suggested for configuration environments like heroku.
helpful link: https://www.oreilly.com/library/view/sinatra-up-and/9781449306847/ch04.html#ch0405
