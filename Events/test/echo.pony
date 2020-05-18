use ".."
use "ponytest"

class Echo is Event[Stringable val]
  let _t: TestHelper
  new create(t: TestHelper) =>
    _t = t
  fun ref apply(data: Stringable) =>
    _t.assert_true(data.string() == "repeat this message")
    _t.assert_true(data.string() != " do not repeat this message")
    _t.log(data.string())


actor EchoEmitter is EventEmitter[Stringable val, Echo iso, Echo tag]
  let _listeners: Array[(Echo, Bool)] = Array[(Echo, Bool)](10)
  let _t: TestHelper
  new create(t: TestHelper) =>
    _t = t
  be echo(str: Stringable val) =>
    _emit[Echo tag](str)
  be done() =>
    _t.complete(true)
  fun ref _emit[E: Echo tag] (data: Stringable) =>
    var i: USize = 0
    var onces: Array[USize] = Array[USize](_listeners.size())
    for listener in _listeners.values() do
      match listener
        | (let listener': E tag , let once': Bool) =>
          listener._1(data.string())
          if once' then
            onces.push(i)
          end
      end
      i = i + 1
    end
    i = 0
    for index in onces.values() do
      try
        _listeners.delete((index - (i = i + 1)))?
      end
    end
  be on(event: Echo iso) =>
    _listeners.push((consume event, false))

  be off(event: Echo tag) =>
      try
        var i: USize = 0
        while i < _listeners.size() do
          if _listeners(i)?._1 is event then
            _listeners.delete(i)?
            break
          else
            i = i + 1
          end
        end
      end
  be once(event: Echo iso) =>
    _listeners.push((consume event, true))
