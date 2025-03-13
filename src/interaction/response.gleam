import gleam/dynamic.{type Dynamic}

pub type Success {
  Pong
  MessageReply
  MessageUpdate
  Deferred
}

pub type Failure {
  NotFound
  NotImplemented
  InternalServerError
  Other(String)
}
