use "ponytest"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)
  new make () =>
    None
  fun tag tests(test: PonyTest) =>
    test(_EchoEventTest)
    test(_MultiEventTest)

class iso _EchoEventTest is UnitTest
  fun name(): String => "Testing Echo Event"
  fun apply(t: TestHelper) =>
    t.long_test(5000000000)
    let echo: Echo iso = recover Echo(t) end
    let echo2: Echo iso = recover Echo(t) end
    let echoEmitter: EchoEmitter = EchoEmitter(t)
    let stub = echo2
    echoEmitter.once(consume echo)
    echoEmitter.echo("repeat this message")
    echoEmitter.echo(" do not repeat this message")
    echoEmitter.once(consume echo2)
    echoEmitter.echo("repeat this message")
    echoEmitter.off(stub)
    echoEmitter.echo(" do not repeat this message")
    echoEmitter.done()

class iso _MultiEventTest is UnitTest
  fun name(): String => "Testing Multi Event"
  fun apply(t: TestHelper) =>
    t.long_test(5000000000)
    t.expect_action("first")
    t.expect_action("second")
    t.expect_action("third")
    let first: First iso = recover First(t) end
    let second: Second iso = recover Second(t) end
    let third: Third iso = recover Third(t) end
    let multiEmitter: MultiEmitter = MultiEmitter
    multiEmitter.once(consume first)
    multiEmitter.once(consume second)
    multiEmitter.once(consume third)
    multiEmitter.first()
    multiEmitter.second()
    multiEmitter.third()
