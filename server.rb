# server.rb

require 'sinatra'
require 'sinatra/namespace'

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

    green = `cat /sys/class/leds/led1/brightness`.delete!("\n")
    leds << Led.new('0', green)

    red = `cat /sys/class/leds/led1/brightness`.delete!("\n")
    leds << Led.new('0', red)
    leds.to_json
  end

  put '/leds/:id/:status' do |id, status|
    puts id + ' ' + status
    halt(404, { message: 'Led Not Found' }.to_json) unless (0..1).include? id.to_i
    `sudo sh -c 'echo #{status} > /sys/class/leds/led#{id}/brightness'`
  end
end

# Models
class Led
  attr_accessor :name, :status

  def initialize(name, status)
    @name = name
    @status = status
  end

  def as_json(options={})
    {
      name: @name,
      status: @status
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end
end
