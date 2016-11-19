require "./spec_helper"

describe Helmet::InternetExplorerNoOpenHandler do
  it "sets the X-Content-Type-Options to nosniff" do
    context = test_context

    handler = Helmet::InternetExplorerNoOpenHandler.new
    handler.call(context)

    context.response.headers["X-Download-Options"].should eq("noopen")
  end
end
