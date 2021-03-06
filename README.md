express-cache-control
=====================

Add caching to your requests in 4 easy steps!


1. Install: `npm install --save express-cache-control`

2. Require: `var CacheControl = require("express-cache-control")`

3. Instantiate: `var cache = new CacheControl().middleware`

4. Mixin it: `app.get("/routetocache", cache("hours", 3), routes.get)`


Other stuff:

- Override caching for development: var cache = new CacheControl({override: 0}).middleware

- The middleware method is bound to the CacheControl instance so you can treat it like a real function `var cache = new CacheControl({override: 0}).middleware`

- leave off the value to assume 1 `cache("hour")`

cache for:
seconds
minutes
hours
days
weeks
months
years

## License
Copyright (c) 2013 i.TV LLC

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
