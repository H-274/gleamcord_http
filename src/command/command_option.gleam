import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/list
import gleam/result

pub type Error {
  NotFound
  WrongType(expected: String)
}

/// TODO replace dynamic when resolved types exist
pub type CommandOption {
  String(name: String, value: String, focused: Bool)
  Integer(name: String, value: Int, focused: Bool)
  Boolean(name: String, value: Bool)
  User(name: String, value: Dynamic)
  Channel(name: String, value: Dynamic)
  Role(name: String, value: Dynamic)
  Mentionable(name: String, value: Dynamic)
  Number(name: String, value: Float, focused: Bool)
  Attachment(name: String, value: Dynamic)
}

pub fn extract_focused(
  options: Dict(String, CommandOption),
) -> Result(CommandOption, Nil) {
  use option <- list.find(dict.values(options))
  case option {
    String(focused: focused, ..)
    | Integer(focused: focused, ..)
    | Number(focused: focused, ..) -> focused
    _ -> False
  }
}

pub fn extract_string(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(String, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    String(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("String"))
  }
}

pub fn extract_integer(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Int, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    Integer(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("Integer"))
  }
}

pub fn extract_boolean(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Bool, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    Boolean(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("Boolean"))
  }
}

pub fn extract_user(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    User(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("User"))
  }
}

pub fn extract_channel(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    Channel(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("Channel"))
  }
}

pub fn extract_role(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    Role(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("Role"))
  }
}

pub fn extract_mentionable(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    Mentionable(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("Mentionable"))
  }
}

pub fn extract_number(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Float, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    Number(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("Number"))
  }
}

pub fn extract_attachment(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    Attachment(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("Attachment"))
  }
}

/// TODO
pub type Definition {
  StringDef
}
