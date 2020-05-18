trait Event[A: Any #send]
  fun ref apply(data: A)

trait EventEmitter[A: Any #send, B: Event[A] iso, C: Event[A] tag]
  be on(event: B)
  be off(event: C)
  be once(event: B)
  fun ref _emit[E:C](data: A)
