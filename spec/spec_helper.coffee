#= require mercury/dependencies
#= require mercury/core/config

@Mercury ||= {}
@JST ||= {}

# define global methods that might not exist
Mercury.on ||= ->
Mercury.trigger ||= ->

# allow configuration to be adjusted and restored after each test
$.extend(Mercury, Mercury.Config.Module)
Mercury.configure = Mercury.Config.set
originalConfig = $.extend(true, {}, Mercury.configuration || {})
afterEach -> Mercury.configuration = $.extend(true, {}, originalConfig)

# ensure console is available to spy on
@console = {debug: ->} unless console?.debug
@console = {error: ->} unless console?.error
@console = {trace: ->} unless console?.trace

# setup mocha / chai
mocha.setup(ignoreLeaks: true)
@expect = chai.expect

# spies / auto cleanup for spyOn
@spy = sinon.spy
@stub = sinon.stub

_spies = []
@spyOn = (thing, method, callback = null) ->
  _spies.push(thing: thing, method: method)
  sinon.stub(thing, method, callback)

afterEach ->
  for spy in _spies
    try spy['thing'][spy['method']].restore()
    catch e
  _spies = []
