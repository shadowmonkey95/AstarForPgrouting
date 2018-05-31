# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

app = proc do |env|
  [
    200,
    {
      'Content-Type' => 'text/html',
      'Content-Length' => '2'
    },
    ['hi']
  ]
 end

run Rails.application
