require "./spec_helper"

describe Helmet::DNSPrefetchControllerHandler do
  it "sets X-DNS-Prefetch-Control header to 'off' by default" do
    context = test_context
    next_handler = TestNext.new

    handler = Helmet::DNSPrefetchControllerHandler.new
    handler.next = next_handler
    handler.call(context)

    context.response.headers["X-DNS-Prefetch-Control"].should eq("off")
    next_handler.called.should be_true
  end

  it "sets X-DNS-Prefetch-Control header to 'off' if specified" do
    context = test_context
    next_handler = TestNext.new

    handler = Helmet::DNSPrefetchControllerHandler.new(allowed: false)
    handler.next = next_handler
    handler.call(context)

    context.response.headers["X-DNS-Prefetch-Control"].should eq("off")
    next_handler.called.should be_true
  end

  it "sets X-DNS-Prefetch-Control header to 'on' if specified" do
    context = test_context
    next_handler = TestNext.new

    handler = Helmet::DNSPrefetchControllerHandler.new(allowed: true)
    handler.next = next_handler
    handler.call(context)

    context.response.headers["X-DNS-Prefetch-Control"].should eq("on")
    next_handler.called.should be_true
  end
end
