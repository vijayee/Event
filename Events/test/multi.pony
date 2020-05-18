use ".."
use "ponytest"
class First is Event[None]
  let _t: TestHelper
  new create(t: TestHelper) =>
    _t = t
  fun ref apply(data: None = None) =>
    _t.complete_action("first")

class Second is Event[None]
  let _t: TestHelper
  new create(t: TestHelper) =>
    _t = t
  fun ref apply(data: None = None) =>
    _t.complete_action("second")

class Third is Event[None]
  let _t: TestHelper
  new create(t: TestHelper) =>
    _t = t
  fun ref apply(data: None = None) =>
    _t.complete_action("third")

type MultiEvent is (First | Second | Third)

actor MultiEmitter is EventEmitter[None, MultiEvent iso, MultiEvent tag]
  let _listeners: Array[(MultiEvent, Bool)] = Array[(MultiEvent, Bool)](10)
  be first() =>
    _emit[First tag]()
  be second() =>
    _emit[Second tag]()
  be third() =>
    _emit[Third tag]()
  fun ref _emit[E: MultiEvent tag] (data: None = None) =>
    var i: USize = 0
    var onces: Array[USize] = Array[USize](_listeners.size())
    for listener in _listeners.values() do
      match listener
        | (let listener': E tag , let once': Bool) =>
          listener._1()
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
  be on(event: MultiEvent iso) =>
    _listeners.push((consume event, false))

  be off(event: MultiEvent tag) =>
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
  be once(event: MultiEvent iso) =>
    _listeners.push((consume event, true))
