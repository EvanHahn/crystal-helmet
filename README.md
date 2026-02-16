# Helmet

Helmet helps you secure your Crystal web apps by setting various HTTP headers. *It's not a silver bullet*, but it can help!

This is a port of the [Node.js version of Helmet](https://github.com/helmetjs/helmet).

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  helmet:
    github: EvanHahn/crystal-helmet
```


## Usage

Helmet is a collection of smaller handlers that set HTTP headers. You need to register them to your web application's handler chain. See [the documentation](https://evanhahn.github.io/crystal-helmet/) for all available handlers.

Here's how to plug Helmet into some of the **most popular Crystal web frameworks**:

#### Kemal

In Kemal you would use the `use` method to register the Helmet handlers:

```crystal
require "kemal"
require "helmet"

use Helmet::DNSPrefetchControllerHandler.new
use Helmet::FrameGuardHandler.new
use Helmet::InternetExplorerNoOpenHandler.new
use Helmet::NoSniffHandler.new
use Helmet::StrictTransportSecurityHandler.new(7.days)
use Helmet::XSSFilterHandler.new

get "/" do |env|
  "Protected by Helmet"
end

Kemal.run
```

#### HTTP::Server (Standalone)

When using the standard library `HTTP::Server`, any middleware is registered as part of the initializer:

```crystal
require "http/server"
require "helmet"

server = HTTP::Server.new(
  [
    Helmet::DNSPrefetchControllerHandler.new,
    Helmet::FrameGuardHandler.new,
    Helmet::InternetExplorerNoOpenHandler.new,
    Helmet::NoSniffHandler.new,
    Helmet::StrictTransportSecurityHandler.new(7.day),
    Helmet::XSSFilterHandler.new,
  ]) do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world!"
end

address = server.bind_tcp(8080)

server.listen
```


## Contributing


1. Fork it (https://github.com/EvanHahn/crystal-helmet/fork)
2. Create your branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add XYZ'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request


## Contributors


- [Evan Hahn](https://evanhahn.com) - creator, maintainer
- [Du Ba Thach](https://bthachdev.github.io/) - [#3](https://github.com/EvanHahn/crystal-helmet/pull/3)
- [Serdar Doğruyol](https://serdardogruyol.com/) - [#9](https://github.com/EvanHahn/crystal-helmet/pull/9)
