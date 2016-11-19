require "./spec_helper"

describe Helmet::DNSPrefetchControllerHandler do
  it "sets X-DNS-Prefetch-Control header to 'off' by default" do
    context = test_context

    handler = Helmet::DNSPrefetchControllerHandler.new
    handler.call(context)

    context.response.headers["X-DNS-Prefetch-Control"].should eq("off")
  end

  it "sets X-DNS-Prefetch-Control header to 'off' if specified" do
    context = test_context

    handler = Helmet::DNSPrefetchControllerHandler.new(allowed: false)
    handler.call(context)

    context.response.headers["X-DNS-Prefetch-Control"].should eq("off")
  end

  it "sets X-DNS-Prefetch-Control header to 'on' if specified" do
    context = test_context

    handler = Helmet::DNSPrefetchControllerHandler.new(allowed: true)
    handler.call(context)

    context.response.headers["X-DNS-Prefetch-Control"].should eq("on")
  end
end
