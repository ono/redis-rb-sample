require 'sinatra'
require 'redis'
require 'rack/fiber_pool'

$stdout.sync = true

class SampleApp < Sinatra::Base
  enable :raise_errors
  enable :show_exceptions

  use Rack::FiberPool

  def self.redis
    @redis ||= Redis.new(driver: :synchrony)
  end

  def self.issue_request_number
    @number ||= 0
    @number += 1
  end

  def redis
    SampleApp.redis
  end

  def attributes
    @attributes ||= {
      "id" => "test-81ccfb60-ab4c-0130-420a-080027feaaaf",
      "user_name" => "ono",
      "type" => "test",
      "start_time" => "2013-09-09 10:34:08 +0000"
    }
  end

  def request_number
    @request_number ||= SampleApp.issue_request_number
  end

  get '/' do
    puts "#{request_number}: START"

    hkey = "h-test"
    zkey = "z-test"

    id = attributes["id"]

    redis.hmset hkey, *attributes.to_a.flatten

    redis.zadd "z-test", Time.now.to_i, id
    redis.hgetall hkey
    redis.zscore zkey, id

    puts "#{request_number}: DONE"

    [200, "REDIS: OK"]
  end

end

run Rack::URLMap.new("/" => SampleApp.new)
