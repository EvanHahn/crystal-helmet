require "./spec_helper"

describe Helmet::StrictTransportSecurityHandler do
  it "can set the header with just a max-age" do
    context = test_context
    next_handler = TestNext.new

    handler = Helmet::StrictTransportSecurityHandler.new(90.day)
    handler.next = next_handler
    handler.call(context)

    context.response.headers["Strict-Transport-Security"].should eq("max-age=7776000")
    next_handler.called.should be_true
  end

  it "can set the max-age to 0" do
    context = test_context
    next_handler = TestNext.new

    handler = Helmet::StrictTransportSecurityHandler.new(Time::Span.new(0))
    handler.next = next_handler
    handler.call(context)

    context.response.headers["Strict-Transport-Security"].should eq("max-age=0")
    next_handler.called.should be_true
  end

  it "rounds the max-age down properly" do
    context = test_context
    next_handler = TestNext.new

    handler = Helmet::StrictTransportSecurityHandler.new(1400.millisecond)
    handler.next = next_handler
    handler.call(context)

    context.response.headers["Strict-Transport-Security"].should eq("max-age=1")
    next_handler.called.should be_true
  end

  it "rounds the max-age up properly" do
    context = test_context
    next_handler = TestNext.new

    handler = Helmet::StrictTransportSecurityHandler.new(1600.millisecond)
    handler.next = next_handler
    handler.call(context)

    context.response.headers["Strict-Transport-Security"].should eq("max-age=2")
    next_handler.called.should be_true
  end

  it "can include subdomains" do
    context = test_context
    next_handler = TestNext.new

    handler = Helmet::StrictTransportSecurityHandler.new(90.day, include_subdomains: true)
    handler.next = next_handler
    handler.call(context)

    context.response.headers["Strict-Transport-Security"].should eq("max-age=7776000; includeSubDomains")
    next_handler.called.should be_true
  end

  it "can preload" do
    context = test_context
    next_handler = TestNext.new

    handler = Helmet::StrictTransportSecurityHandler.new(1.day, preload: true)
    handler.next = next_handler
    handler.call(context)

    context.response.headers["Strict-Transport-Security"].should eq("max-age=86400; preload")
    next_handler.called.should be_true
  end

  it "can include subdomains and preload" do
    context = test_context
    next_handler = TestNext.new

    handler = Helmet::StrictTransportSecurityHandler.new(1.day,
      include_subdomains: true,
      preload: true)
    handler.next = next_handler
    handler.call(context)

    context.response.headers["Strict-Transport-Security"].should eq("max-age=86400; includeSubDomains; preload")
    next_handler.called.should be_true
  end
end
