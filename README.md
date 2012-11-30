express-cache-control
=====================

Add caching to your requests in 4 easy steps!


1. Install: `npm install --save express-cache-control`

2. Require: `var CacheControl = require("express-cache-control")`

3. Instantiate: `var cache = new CacheControl().middleware`

4. Use it: `app.get("/routetocache", cache("hours", 3), routes.get)`


Other stuff:

- Override caching for development: var cache = new CacheControl({override: 0}).middleware

- The middleware method is bound to the CacheControl instance so you can treat
  it like a real function `var cache = new CacheControl({override: 0}).middleware`

- leave off the value to assume 1 `cache("hour")`

cache for:
seconds
minutes
hours
days
weeks
months
years


## Options

The following options can be passed to the constructor.

- `override` number - Override all cache settings with a cache header for this
  number of seconds. Useful for development or testing.
- `dontOverwriteIfSet` boolean - if true, will not set headers if they already
  have a `Cache-Control` header set. Useful if you are setting cache headers
  programmatically but want to have a default to fall back to.
- `copyFromReq` boolean - if true and the incoming request has a `Cache-Control`
  header, copy it over to the response object instead adding the specified
  cache header.
