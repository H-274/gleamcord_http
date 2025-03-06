pub type Success {
  Pong
}

pub type Failure {
  NotFound
  NotImplemented
  InternalServerError
  Other(String)
}
