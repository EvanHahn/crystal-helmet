require "http/server"

module Helmet
  # When your webpage can be put in a frame (like an `iframe`), you can be
  # vulnerable to a kind of attack called [clickjacking](https://en.wikipedia.org/wiki/Clickjacking),
  # where your page is invisible on another page but is being interacted with.
  #
  # The `X-Frame-Options` HTTP header restricts who can put your site in a
  # frame. It has three modes: `DENY`, `SAMEORIGIN`, and `ALLOW-FROM`.
  #
  # - `DENY` will prevent anyone from rendering this page in a frame.
  # - `SAMEORIGIN` will only allow pages on the same origin to put this page in a frame. For example, if this header were set on `http://example.com/about.html` then `http://example.com/store.html` could render it, but `http://evanhahn.com/store.html` could not.
  # - `ALLOW-FROM` lets you specify a specific origin that is allowed to put this page in frames.
  #
  # ### Allow this page to be put in frames on the same origin
  #
  # You can specify this explicitly:
  #
  # ```
  # sameorigin = Helmet::FrameGuardHandler::Origin::Same
  # server = HTTP::Server.new("0.0.0.0", 8080, [
  #   Helmet::FrameGuardHandler.new allow_from: sameorigin,
  #   # ...
  # ])
  # ```
  #
  # It's also the default:
  #
  # ```
  # server = HTTP::Server.new("0.0.0.0", 8080, [
  #   Helmet::FrameGuardHandler.new,
  #   # ...
  # ])
  # ```
  #
  # ### Don't allow this page to be put in frames (from anywhere)
  #
  # ```
  # nowhere = Helmet::FrameGuardHandler::Origin::Nowhere
  # server = HTTP::Server.new("0.0.0.0", 8080, [
  #   Helmet::FrameGuardHandler.new allow_from: nowhere,
  # ])
  # ```
  #
  # ### Allow this page to be framed by a specific origin
  #
  # ```
  # server = HTTP::Server.new("0.0.0.0", 8080, [
  #   Helmet::FrameGuardHandler.new allow_from: "http://example.com",
  #   # ...
  # ])
  # ```
  class FrameGuardHandler < HTTP::Handler
    def initialize(allow_from = Origin::Same)
      case allow_from
      when String
        @value = "ALLOW-FROM #{allow_from}"
      when Origin
        @value = allow_from.to_s
      else
        raise "#{allow_from} is not a valid allow_from option"
      end
    end

    def call(context : HTTP::Server::Context)
      context.response.headers["X-Frame-Options"] = @value
      call_next(context)
    end

    # The `Origin` enum is used as an argument in the `FrameGuardHandler`
    # constructor. You use it to specify the `SAMEORIGIN` or `DENY` headers
    # values.
    #
    # ```
    # sameorigin = Helmet::FrameGuardHandler::Origin::Same
    # handler = Helmet::FrameGuardHandler.new allow_from: sameorigin
    # ```
    enum Origin : UInt8
      # Corresponds to the `SAMEORIGIN` header value.
      Same

      # Corresponds to the `DENY` header value.
      Nowhere

      # Convert this `Origin` to a string. `Origin::Same` becomes `"SAMEORIGIN"`
      # and `Origin::Nowhere` becomes `"DENY"`.
      def to_s
        case self
        when Same
          "SAMEORIGIN"
        when Nowhere
          "DENY"
        else
          raise "unknown origin: #{self}"
        end
      end
    end
  end
end
