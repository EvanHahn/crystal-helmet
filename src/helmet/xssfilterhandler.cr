require "http/server"

module Helmet
  # The `X-XSS-Protection` HTTP header is a basic protection against cross-site
  # scripting attacks. It was originally [by Microsoft](http://blogs.msdn.com/b/ieinternals/archive/2011/01/31/controlling-the-internet-explorer-xss-filter-with-the-x-xss-protection-http-header.aspx)
  # but Chrome has since adopted it as well.
  #
  # This handler sets the `X-XSS-Protection` header. On modern browsers, it
  # will set the value to `1; mode=block`. On old versions of Internet
  # Explorer, this creates a vulnerability (see [here](http://hackademix.net/2009/11/21/ies-xss-filter-creates-xss-vulnerabilities/)
  # and [here](http://technet.microsoft.com/en-us/security/bulletin/MS10-002)),
  # and so the header is set to `0` to disable it.
  #
  # Example usage:
  #
  # ```
  # server = HTTP::Server.new("0.0.0.0", 8080, [
  #   Helmet::XSSFilterHandler.new,
  #   # ...
  # ])
  # ```
  #
  # To force the header to be set to `1; mode=block` on all versions of
  # Internet Explorer, add the `set_on_old_ie` option:
  #
  # ```
  # server = HTTP::Server.new("0.0.0.0", 8080, [
  #   Helmet::XSSFilterHandler.new(set_on_old_ie: true),
  #   # ...
  # ])
  # ```
  class XSSFilterHandler < HTTP::Handler
    def initialize(@set_on_old_ie : Bool = false)
    end

    def call(context : HTTP::Server::Context)
      useragent = context.request.headers.fetch("User-Agent", "").downcase
      value = "1; mode=block"
      unless @set_on_old_ie
        useragent.scan(/msie\s+(\d+)/) do |match|
          value = "0" if match[1].to_i < 9
        end
      end

      context.response.headers["X-XSS-Protection"] = value
      call_next(context)
    end
  end
end
