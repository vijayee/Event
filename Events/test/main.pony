use "ponytest"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)
  new make () =>
    None
  fun tag tests(test: PonyTest) =>
    test(_EchoEventTest)

class iso _EchoEventTest is UnitTest
  fun name(): String => "Testing Echo Event"
  fun apply(t: TestHelper) =>
    let echo: Echo iso = recover Echo(t) end
    let echo2: Echo iso = recover Echo(t) end
    let echoEmitter: EchoEmitter = EchoEmitter
    let stub = echo2
    echoEmitter.once(consume echo)
    echoEmitter.echo("repeat this message")
    echoEmitter.echo(" do not repeat this message")
    echoEmitter.once(consume echo2)
    echoEmitter.echo("repeat this message")
    echoEmitter.off(stub)
    echoEmitter.echo(" do not repeat this message")
