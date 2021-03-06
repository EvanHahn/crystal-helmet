require "./spec_helper"

describe Helmet::NoSniffHandler do
  it "sets the X-Content-Type-Options to nosniff" do
    context = test_context
    next_handler = TestNext.new

    handler = Helmet::NoSniffHandler.new
    handler.next = next_handler
    handler.call(context)

    context.response.headers["X-Content-Type-Options"].should eq("nosniff")
    next_handler.called.should be_true
  end
end
