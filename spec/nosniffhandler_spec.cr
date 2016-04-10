require "./spec_helper"
require "http/server"

describe Helmet::NoSniffHandler do
  it "sets the X-Content-Type-Options to nosniff" do
    request = HTTP::Request.new("GET", "/")
    response = HTTP::Server::Response.new(MemoryIO.new)
    context = HTTP::Server::Context.new(request, response)

    log_io = MemoryIO.new
    handler = Helmet::NoSniffHandler.new
    next_called = false
    handler.next = ->(ctx : HTTP::Server::Context) { next_called = true }
    handler.call(context)

    (response.headers.has_key? "X-Content-Type-Options").should be_true
    response.headers["X-Content-Type-Options"].should eq("nosniff")
    next_called.should be_true
  end
end
