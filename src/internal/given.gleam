pub fn ok(in result: Result(a, b), then then: c, else_ otherwise: fn(b) -> c) {
  case result {
    Ok(_) -> then
    Error(err) -> otherwise(err)
  }
}

pub fn error(in result: Result(a, b), then then: c, else_ otherwise: fn(a) -> c) {
  case result {
    Error(_) -> then
    Ok(val) -> otherwise(val)
  }
}

pub fn lazy_error(
  in result: Result(a, b),
  then then: fn(b) -> c,
  else_ otherwise: fn(a) -> c,
) {
  case result {
    Error(err) -> then(err)
    Ok(val) -> otherwise(val)
  }
}
