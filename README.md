rack-cleancookies
=================

Clean dirty cookies from Rack environment and prevent Rack applications to stop working because of dirty cookies not conforming to RFC specifications.

Install
=======

Just edit your Gemfile and add:

```ruby
gem 'rack-cleancookies'
```

then add Rack::CleanCookies::Middleware to your Rack stack, e.g.:

```ruby
use Rack::CleanCookies::Middleware
```

if you prefer to have the rack-errors env variable filled with dirty cookies, use:

```ruby
use Rack::CleanCookies::Middleware, verbose: true
```


Authors
=======
The original version was provided as a gist by Eric Cohen (https://github.com/eirc). Thanks!
