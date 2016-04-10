require "http/server/handler"

module Helmet
  # Some browsers optimistically prefetch DNS records for performance, which can
  # have security implications. Read more about it [on MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Controlling_DNS_prefetching)
  # and [on Chromium's docs](https://dev.chromium.org/developers/design-documents/dns-prefetching).
  #
  # This handler sets the `X-DNS-Prefetch-Control` to control browsers' DNS
  # prefetching behavior.
  #
  # ### Disable DNS prefetching
  #
  # You can disable DNS prefetching:
  #
  # ```
  # server = HTTP::Server.new("0.0.0.0", 8080, [
  #   Helmet::DNSPrefetchControllerHandler.new(allow: false),
  #   # ...
  # ])
  # ```
  #
  # You can also leave out the `allow` argument if you're doing this—`false` is
  # the default:
  #
  # ```
  # server = HTTP::Server.new("0.0.0.0", 8080, [
  #   Helmet::DNSPrefetchControllerHandler.new,
  #   # ...
  # ])
  # ```
  #
  # ### Enable DNS prefetching
  #
  # ```
  # server = HTTP::Server.new("0.0.0.0", 8080, [
  #   Helmet::DNSPrefetchControllerHandler.new(allow: true),
  #   # ...
  # ])
  # ```
  class DNSPrefetchControllerHandler < HTTP::Handler
    def initialize(allowed : Bool = false)
      @value = allowed ? "on" : "off"
    end

    def call(context)
      context.response.headers["X-DNS-Prefetch-Control"] = @value
      call_next(context)
    end
  end
end
