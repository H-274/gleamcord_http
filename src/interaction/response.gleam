// TODO
pub type Success {
  Pong
  MessageReply
  DeferredReply
  MessageUpdate
  DeferredUpdate
}

pub type Failure {
  NotFound
  NotImplemented
  InternalServerError
  Other(String)
}
