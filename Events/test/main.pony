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
