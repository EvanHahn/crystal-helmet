require "http/server/handler"

module Helmet
  # Some web applications will serve untrusted HTML for download. By default,
  # some versions of Internet Explorer will allow you to open those HTML files
  # in the context of your site, which means that an untrusted HTML page could
  # start doing bad things in the context of your pages. For more, see [this
  # MSDN blog post](http://blogs.msdn.com/b/ie/archive/2008/07/02/ie8-security-part-v-comprehensive-protection.aspx).
  #
  # This handler sets the `X-Download-Options` header to `noopen` to prevent IE
  # users from executing downloads in your site's context.
  #
  # Example usage:
  #
  # ```
  # server = HTTP::Server.new("0.0.0.0", 8080, [
  #   Helmet::InternetExplorerNoOpenHandler.new,
  # ])
  # ```
  class InternetExplorerNoOpenHandler < HTTP::Handler
    def call(context)
      context.response.headers["X-Download-Options"] = "noopen"
      call_next(context)
    end
  end
end
