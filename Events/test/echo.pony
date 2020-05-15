use ".."
use "ponytest"

class Echo is Event[Stringable val]
  let _t: Env
  new create(env: Env) =>
    _env = env
  fun ref apply(data: Stringable) =>
    _env.out.print(data.string())


actor EchoEmitter is EventEmitter[Stringable val, Echo iso, Echo tag]
  let _listeners: Array[(Echo, Bool)] = Array[(Echo, Bool)](10)
  be echo(str: Stringable val) =>
    _emit[Echo tag](str)
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
    for index in onces.values() do
      try
        _listeners.delete(index)?
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
