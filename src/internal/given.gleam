import gleam/option.{type Option}

pub fn true(
  that condition: Bool,
  then then: fn() -> a,
  else_ otherwise: fn() -> a,
) {
  case condition {
    True -> then()
    False -> otherwise()
  }
}

pub fn false(
  that condition: Bool,
  then then: fn() -> a,
  else_ otherwise: fn() -> a,
) {
  case condition {
    False -> then()
    True -> otherwise()
  }
}

pub fn ok(
  in result: Result(a, b),
  then then: fn(a) -> c,
  else_ otherwise: fn(b) -> c,
) {
  case result {
    Ok(val) -> then(val)
    Error(err) -> otherwise(err)
  }
}

pub fn error(
  in result: Result(a, b),
  then then: fn(b) -> c,
  else_ otherwise: fn(a) -> c,
) {
  case result {
    Error(err) -> then(err)
    Ok(val) -> otherwise(val)
  }
}

pub fn some(
  in option: Option(a),
  then then: fn(a) -> b,
  else_ otherwise: fn() -> b,
) {
  case option {
    option.Some(val) -> then(val)
    option.None -> otherwise()
  }
}

pub fn none(
  in option: Option(a),
  then then: fn() -> b,
  else_ otherwise: fn(a) -> b,
) {
  case option {
    option.None -> then()
    option.Some(val) -> otherwise(val)
  }
}

pub fn is(
  expected expected: a,
  from from: a,
  then then: fn(a) -> b,
  else_ otherwise: fn() -> b,
) {
  case from {
    expected -> then(from)
    _ -> otherwise()
  }
}

pub fn is_not(
  expected expected: a,
  from from: a,
  then then: fn(a) -> b,
  else_ otherwise: fn() -> b,
) {
  case from {
    expected -> otherwise()
    _ -> then(from)
  }
}
