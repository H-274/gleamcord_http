pub type Response {
  JsonString(String)
}

pub type Error {
  NotImplemented
}

pub type Handler(val) =
  fn(val) -> Result(Response, Error)

pub fn default_handler(_) {
  Error(NotImplemented)
}
