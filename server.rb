# server.rb

require 'sinatra'
require 'sinatra/namespace'
require 'pry'

# Listen on all interfaces in the development environment
set :bind, '0.0.0.0'

# Endpoints
get '/' do
  'Welcome to Raspian Server'
end

namespace '/api/v1' do
  before do
    content_type 'application/json'
  end

  get '/leds' do
    # green = /sys/class/leds/led0/brightness
    # red = /sys/class/leds/led1/brightness
    leds = []

    green = `cat /sys/class/leds/led0/brightness`.delete!("\n")
    leds << Led.new('green', green)

    red = `cat /sys/class/leds/led1/brightness`.delete!("\n")
    leds << Led.new('red', red)
    leds.to_json
  end

  put '/leds/:id/:status' do |id, status|
    puts id + ' ' + status
    halt(404, { message: 'Led Not Found' }.to_json) unless (0..1).include? id.to_i
    `sudo sh -c 'echo #{status} > /sys/class/leds/led#{id}/brightness'`
  end
end

namespace '/api/v2' do
  before do
    content_type 'application/json'
  end

  get '/leds' do
    # green = /sys/class/leds/led0/brightness
    # red = /sys/class/leds/led1/brightness
    leds = []

    green = `cat /sys/class/leds/led0/brightness`.delete!("\n")
    leds << Led.new('green', green, green.to_i.to_b?)

    red = `cat /sys/class/leds/led1/brightness`.delete!("\n")
    leds << Led.new('red', red, red.to_i.to_b?)
    leds.to_json
  end

  get '/leds/:led' do |led|
    case led.downcase
    when 'green'
      id = 0
    when 'red'
      id = 1
    else
      puts id + ' ' + status
      halt(404, { message: 'Led Not Found' }.to_json) unless (0..1).include? id.to_i
    end

    status = `sudo sh -c "cat /sys/class/leds/led#{id}/brightness"`.delete!("\n")
    Led.new(led, status, status.to_i.to_b?).to_json
  end

  post '/leds/:led' do |led|
    case led.downcase
    when 'green'
      id = 0
    when 'red'
      id = 1
    else
      puts id + ' ' + status
      halt(404, { message: 'Led Not Found' }.to_json) unless (0..1).include? id.to_i
    end

    status = JSON.parse(request.body.read)
    `sudo sh -c "echo #{status.values[0]} > /sys/class/leds/led#{id}/brightness"`
  end
end

# Models
class Led
  attr_accessor :name, :status, :is_active

  def initialize(name, status, is_active = nil)
    @name = name
    @status = status
    @is_active = is_active
  end

  def as_json(options={})
    {
      name: @name,
      status: @status,
      is_active: @is_active
    }
  end

  def to_json(*options)
    as_json(*options).reject { |k, v| v.nil? }.to_json(*options)
  end
end

class Integer
  def to_b?
    !self.zero?
  end
end
