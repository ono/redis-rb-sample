## Redis.rb: synchrony dirver fails badly under high concurrent requests

### What is this?

It is a sample sinatra application that reproduce an issue on Redis.rb with
synchrony driver.

### Install

1. Clone this project
2. Then execute `bundle install`

You also need Redis running in your localhost

### Start the application

    bundle exec rackup -p 9001

### Reproduce the problem

Confirm the application connects to redis at first:

    curl "http://127.0.0.1:9001"
    => "REDIS: OK"

Try load test with a single process:

    ab -c 1 -n 100 "http://127.0.0.1:9001/"
    => Gives you fair result

Try load test with 10 concurrency requests:

    ab -c 10 -n 10 "http://127.0.0.1:9001/"
    => You will see concurrent requests failing


