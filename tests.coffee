
CacheControl = require "./cache"
assert = require "assert"
express = require "express"
request = require "request"

PORT = process.env.PORT || 12740
ROUTE = "/test"
URL = "http://localhost:#{PORT}#{ROUTE}"

second = 1
minute = second * 60
hour = minute * 60
day = hour * 24
week = day * 7
month = day * 30
year = day * 365


describe "calculation", ->
  it "should calculate correctly given various units and values", ->
    cc = new CacheControl()
    assert.strictEqual second * 10, cc.calculate("second", 10)
    assert.strictEqual minute * 10, cc.calculate("minute", 10)
    assert.strictEqual hour * 10, cc.calculate("hour", 10)
    assert.strictEqual day * 10, cc.calculate("day", 10)
    assert.strictEqual week * 10, cc.calculate("week", 10)
    assert.strictEqual month * 10, cc.calculate("month", 10)
    assert.strictEqual year * 10, cc.calculate("year", 10)

    assert.strictEqual second * 37, cc.calculate("second", 37)
    assert.strictEqual minute * 37, cc.calculate("minute", 37)
    assert.strictEqual hour * 37, cc.calculate("hour", 37)
    assert.strictEqual day * 37, cc.calculate("day", 37)
    assert.strictEqual week * 37, cc.calculate("week", 37)
    assert.strictEqual month * 37, cc.calculate("month", 37)
    assert.strictEqual year * 37, cc.calculate("year", 37)

  it "should allow more than the maximum of a given unit (like more than 60 minutes)", ->
    cc = new CacheControl()
    assert.strictEqual second * 70, cc.calculate("second", 70)
    assert.strictEqual minute * 70, cc.calculate("minute", 70)
    assert.strictEqual hour * 35, cc.calculate("hour", 35)
    assert.strictEqual day * 439, cc.calculate("day", 439)
    assert.strictEqual week * 8, cc.calculate("week", 8)
    assert.strictEqual month * 33, cc.calculate("month", 33)
    assert.strictEqual year * 3, cc.calculate("year", 3)

  it "should allow the plural of units", ->
    cc = new CacheControl()
    assert.strictEqual second * 10, cc.calculate("seconds", 10)
    assert.strictEqual minute * 10, cc.calculate("minutes", 10)
    assert.strictEqual hour * 10, cc.calculate("hours", 10)
    assert.strictEqual day * 10, cc.calculate("days", 10)
    assert.strictEqual week * 10, cc.calculate("weeks", 10)
    assert.strictEqual month * 10, cc.calculate("months", 10)
    assert.strictEqual year * 10, cc.calculate("years", 10)

  it "should default to 1 of a given unit when none is specified", ->
    cc = new CacheControl()
    assert.strictEqual second, cc.calculate("second")
    assert.strictEqual minute, cc.calculate("minute")
    assert.strictEqual hour, cc.calculate("hour")
    assert.strictEqual day, cc.calculate("day")
    assert.strictEqual week, cc.calculate("week")
    assert.strictEqual month, cc.calculate("month")
    assert.strictEqual year, cc.calculate("year")

    assert.strictEqual second, cc.calculate("seconds")
    assert.strictEqual minute, cc.calculate("minutes")
    assert.strictEqual hour, cc.calculate("hours")
    assert.strictEqual day, cc.calculate("days")
    assert.strictEqual week, cc.calculate("weeks")
    assert.strictEqual month, cc.calculate("months")
    assert.strictEqual year, cc.calculate("years")

  it "should give 0 for 0 of any unit", ->
    cc = new CacheControl()
    assert.strictEqual 0, cc.calculate("seconds", 0)
    assert.strictEqual 0, cc.calculate("minutes", 0)
    assert.strictEqual 0, cc.calculate("hours", 0)
    assert.strictEqual 0, cc.calculate("days", 0)
    assert.strictEqual 0, cc.calculate("weeks", 0)
    assert.strictEqual 0, cc.calculate("months", 0)
    assert.strictEqual 0, cc.calculate("years", 0)

    assert.strictEqual 0, cc.calculate("second", 0)
    assert.strictEqual 0, cc.calculate("minute", 0)
    assert.strictEqual 0, cc.calculate("hour", 0)
    assert.strictEqual 0, cc.calculate("day", 0)
    assert.strictEqual 0, cc.calculate("week", 0)
    assert.strictEqual 0, cc.calculate("month", 0)
    assert.strictEqual 0, cc.calculate("year", 0)

  it "should give 0 for false", ->
    cc = new CacheControl()
    assert.strictEqual 0, cc.calculate(false)

  it "should throw an error for an invalid unit", ->
    cc = new CacheControl()

    assert.throws ->
      cc.calculate "lightyears"
    , Error


describe "middleware", ->
  makeServer = (middleware, handler, cb) ->
    app = express()

    app.get ROUTE, middleware, handler

    server = app.listen PORT

    request URL, (err, res, body) ->
      assert.ifError err
      assert.equal "ok", body
      cb res
      server.close()

  it "should set the cache control header on responses", (done) ->
    cc = new CacheControl()

    handler = (req, res) ->
      res.send "ok"

    makeServer cc.middleware("hours", 2), handler, (res) ->
      assert.equal res.headers["cache-control"], "max-age=7200, must-revalidate"
      done()

  it "should allow the route handler to set the cache header", (done) ->
    cc = new CacheControl()

    handler = (req, res) ->
      res.header "cache-control", "no-cache"
      res.send "ok"

    makeServer cc.middleware("hours", 2), handler, (res) ->
      assert.equal res.headers["cache-control"], "no-cache"
      done()

  it "should be bound to its context", (done) ->
    cache = new CacheControl().middleware

    handler = (req, res) ->
      res.send "ok"

    makeServer cache("hours", 2), handler, (res) ->
      assert.equal res.headers["cache-control"], "max-age=7200, must-revalidate"
      done()

