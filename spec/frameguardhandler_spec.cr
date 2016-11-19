require "./spec_helper"

describe Helmet::FrameGuardHandler do
  it "sets the header to SAMEORIGIN with no arguments" do
    context = test_context

    handler = Helmet::FrameGuardHandler.new
    handler.call(context)

    context.response.headers["X-Frame-Options"].should eq("SAMEORIGIN")
  end

  it "sets the header to DENY" do
    context = test_context

    nowhere = Helmet::FrameGuardHandler::Origin::Nowhere
    handler = Helmet::FrameGuardHandler.new allow_from: nowhere
    handler.call(context)

    context.response.headers["X-Frame-Options"].should eq("DENY")
  end

  it "sets the header to SAMEORIGIN" do
    context = test_context

    sameorigin = Helmet::FrameGuardHandler::Origin::Same
    handler = Helmet::FrameGuardHandler.new allow_from: sameorigin
    handler.call(context)

    context.response.headers["X-Frame-Options"].should eq("SAMEORIGIN")
  end

  it "sets the header to ALLOW-FROM" do
    context = test_context

    handler = Helmet::FrameGuardHandler.new allow_from: "http://example.com"
    handler.call(context)

    context.response.headers["X-Frame-Options"].should eq("ALLOW-FROM http://example.com")
  end
end
