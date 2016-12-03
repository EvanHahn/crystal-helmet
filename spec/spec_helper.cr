require "spec"
require "http/server"
require "../src/helmet"

def test_context : HTTP::Server::Context
  request = HTTP::Request.new("GET", "/")
  response = HTTP::Server::Response.new(IO::Memory.new)
  HTTP::Server::Context.new(request, response)
end

class TestNext < HTTP::Handler
  getter called
  @called = false

  def call(context : HTTP::Server::Context)
    @called = true
  end
end
