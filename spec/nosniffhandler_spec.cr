require "./spec_helper"

describe Helmet::NoSniffHandler do
  it "sets the X-Content-Type-Options to nosniff" do
    context = test_context

    handler = Helmet::NoSniffHandler.new
    handler.call(context)

    context.response.headers["X-Content-Type-Options"].should eq("nosniff")
  end
end
