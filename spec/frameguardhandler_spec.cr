require "./spec_helper"

describe Helmet::FrameGuardHandler do
  it "sets the header to SAMEORIGIN with no arguments" do
    context = test_context
    next_handler = TestNext.new

    handler = Helmet::FrameGuardHandler.new
    handler.next = next_handler
    handler.call(context)

    context.response.headers["X-Frame-Options"].should eq("SAMEORIGIN")
    next_handler.called.should be_true
  end

  it "sets the header to DENY" do
    context = test_context
    next_handler = TestNext.new

    nowhere = Helmet::FrameGuardHandler::Origin::Nowhere
    handler = Helmet::FrameGuardHandler.new allow_from: nowhere
    handler.next = next_handler
    handler.call(context)

    context.response.headers["X-Frame-Options"].should eq("DENY")
    next_handler.called.should be_true
  end

  it "sets the header to SAMEORIGIN" do
    context = test_context
    next_handler = TestNext.new

    sameorigin = Helmet::FrameGuardHandler::Origin::Same
    handler = Helmet::FrameGuardHandler.new allow_from: sameorigin
    handler.next = next_handler
    handler.call(context)

    context.response.headers["X-Frame-Options"].should eq("SAMEORIGIN")
    next_handler.called.should be_true
  end

  it "sets the header to ALLOW-FROM" do
    context = test_context
    next_handler = TestNext.new

    handler = Helmet::FrameGuardHandler.new allow_from: "http://example.com"
    handler.next = next_handler
    handler.call(context)

    context.response.headers["X-Frame-Options"].should eq("ALLOW-FROM http://example.com")
    next_handler.called.should be_true
  end
end
