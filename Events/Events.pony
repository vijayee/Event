trait Event[A: Any #send]
  fun ref apply(data: A)

trait EventEmitter[A: Any #send, B: Event[A] iso, C: Event[A] tag]
  be on(event: B)
  be off(event: C)
  be once(event: B)
  fun ref _emit[E:C](data: A)





actor Main
  new create(env: Env) =>
    let echo: Echo iso = recover Echo(env) end
    let echoEmitter: EchoEmitter = EchoEmitter
    let stub = echo
    echoEmitter.once(consume echo)
    echoEmitter.echo("Shawty lethal")
    //echoEmitter.off(stub)
    echoEmitter.echo("Klingon Homeworld")
