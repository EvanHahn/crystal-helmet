require "http/server/handler"

module Helmet
  class NoSniffHandler < HTTP::Handler
    def call(context)
      context.response.headers["X-Content-Type-Options"] = "nosniff"
      call_next(context)
    end
  end
end
