pub type Handler(val) =
  fn(val) -> Nil

pub fn default_handler(_) {
  Nil
}
