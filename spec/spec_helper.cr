require "spec"
require "http/server"
require "../src/helmet"

def test_context : HTTP::Server::Context
  request = HTTP::Request.new("GET", "/")
  response = HTTP::Server::Response.new(MemoryIO.new)
  HTTP::Server::Context.new(request, response)
end
