require "http/server/handler"

module Helmet
  # Some browsers will try to "sniff" mimetypes. For example, if my server
  # serves `file.txt` with a `text/plain` content-type, some browsers can still
  # run that file with `&lt;script src="file.txt"&gt;&lt;/script&gt;`. Many
  # browsers will allow `file.js` to be run even if the content-type isn't for
  # JavaScript. [There are some other vulnerabilities, too.](http://miki.it/blog/2014/7/8/abusing-jsonp-with-rosetta-flash/)
  #
  # Luckily, browsers listen for a header called `X-Content-Type-Options`. If
  # it's set to the value of `nosniff`, these browsers won't do this mimetype
  # sniffing. ([MSDN has a good description](http://msdn.microsoft.com/en-us/library/gg622941%28v=vs.85%29.aspx)
  # of how browsers behave when they receive this header.)
  #
  # Example usage:
  #
  # ```
  # server = HTTP::Server.new("0.0.0.0", 8080, [
  #   Helmet::NoSniffHandler.new,
  # ])
  # ```
  class NoSniffHandler < HTTP::Handler
    def call(context)
      context.response.headers["X-Content-Type-Options"] = "nosniff"
      call_next(context)
    end
  end
end
