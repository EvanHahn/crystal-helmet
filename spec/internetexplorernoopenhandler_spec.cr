require "./spec_helper"

describe Helmet::InternetExplorerNoOpenHandler do
  it "sets the X-Content-Type-Options to nosniff" do
    context = test_context
    next_handler = TestNext.new

    handler = Helmet::InternetExplorerNoOpenHandler.new
    handler.next = next_handler
    handler.call(context)

    context.response.headers["X-Download-Options"].should eq("noopen")
    next_handler.called.should be_true
  end
end
