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


```crystal
require "http/server"
require "helmet"

server = HTTP::Server.new("0.0.0.0", 8080,
  [
    Helmet::InternetExplorerNoOpenHandler,
    Helmet::NoSniffHandler,
  ]) do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world!"
end

server.listen
```


Helmet is really just a collection of smaller handlers that set HTTP headers. See them listed in the example above and in [the documentation](https://evanhahn.github.io/crystal-helmet/).


## Contributing


1. Fork it (https://github.com/EvanHahn/crystal-helmet/fork)
2. Create your branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add XYZ'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request


## Contributors


- [Evan Hahn](http://evanhahn.com) - creator, maintainer
