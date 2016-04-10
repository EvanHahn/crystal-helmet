require "http/server"

module Helmet
  # This handler adds the `Strict-Transport-Security` header to the response.
  # This tells browsers, "hey, only use HTTPS for the next period of time".
  # ([See the spec](http://tools.ietf.org/html/rfc6797) for more.)
  #
  # ### Tell browsers to use HTTPS for the next 90 days
  #
  # ```
  # server = HTTP::Server.new("0.0.0.0", 8080, [
  #   Helmet::StrictTransportSecurityHandler.new(90.day),
  #   # ...
  # ])
  # ```
  #
  # ### Include subdomains
  #
  # You can also include subdomains. If this is set on *example.com*, supported
  # browsers will also use HTTPS on *my-subdomain.example.com*. Here's how you
  # do that:
  #
  # ```
  # server = HTTP::Server.new("0.0.0.0", 8080, [
  #   Helmet::StrictTransportSecurityHandler.new(90.day,
  #     include_subdomains: true),
  #   # ...
  # ])
  # ```
  #
  # ### Bake this into Chrome
  #
  # Chrome lets you submit your site for baked-into-Chrome HSTS by adding
  # `preload` to the header. You can add that with the following code, and then
  # submit your site to the Chrome team at [hstspreload.appspot.com](https://hstspreload.appspot.com/).
  #
  # ```
  # server = HTTP::Server.new("0.0.0.0", 8080, [
  #   Helmet::StrictTransportSecurityHandler.new(90.day,
  #     include_subdomains: true,
  #     preload: true),
  #   # ...
  # ])
  # ```
  #
  # Note that the max-age (the first argument) must be at least 18 weeks to be
  # approved by Google. The `include_subdomains` option must also be set.
  class StrictTransportSecurityHandler < HTTP::Handler
    def initialize(max_age : Time::Span, include_subdomains : Bool = false, preload : Bool = false)
      @value = "max-age=#{max_age.total_seconds.round.to_i}"
      @value += "; includeSubDomains" if include_subdomains
      @value += "; preload" if preload
    end

    def call(context : HTTP::Server::Context)
      context.response.headers["Strict-Transport-Security"] = @value
      call_next(context)
    end
  end
end
