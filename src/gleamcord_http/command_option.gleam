import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option
import gleam/result
import gleamcord_http/discord

pub type CommandOption {
  String(
    name: String,
    description: String,
    min_len: Int,
    max_len: Int,
    required: Bool,
  )
  StringChoice(
    name: String,
    description: String,
    choices: List(#(String, String)),
    required: Bool,
  )
  StringAutocomplete(
    name: String,
    description: String,
    min_len: Int,
    max_len: Int,
    required: Bool,
    run: fn(discord.Interaction, String) -> List(#(String, String)),
  )
  Integer(
    name: String,
    description: String,
    min_value: Int,
    max_value: Int,
    required: Bool,
  )
  IntegerChoice(
    name: String,
    description: String,
    choices: List(#(String, Int)),
    required: Bool,
  )
  IntegerAutocomplete(
    name: String,
    description: String,
    min_value: Int,
    max_value: Int,
    required: Bool,
    run: fn(discord.Interaction, Int) -> List(#(String, Int)),
  )
  Booolean(name: String, description: String, required: Bool)
  User(name: String, description: String, required: Bool)
  Channel(
    name: String,
    description: String,
    channel_types: List(Int),
    required: Bool,
  )
  Role(name: String, description: String, required: Bool)
  Mentionable(name: String, description: String, required: Bool)
  Number(
    name: String,
    description: String,
    min_value: Float,
    max_value: Float,
    required: Bool,
  )
  NumberChoice(
    name: String,
    description: String,
    choices: List(#(String, Float)),
    required: Bool,
  )
  NumberAutocomplete(
    name: String,
    description: String,
    min_value: Float,
    max_value: Float,
    required: Bool,
    run: fn(discord.Interaction, Float) -> List(#(String, Float)),
  )
  Attachment(name: String, description: String, required: Bool)
}

pub fn get_string_value(
  opts options: Dict(String, Dynamic),
  name name: String,
) {
  dict.get(options, name)
  |> result.replace_error([])
  |> result.map(decode.run(_, decode.string))
  |> result.flatten
}

pub fn get_integer_value(
  opts options: Dict(String, Dynamic),
  name name: String,
) {
  dict.get(options, name)
  |> result.replace_error([])
  |> result.map(decode.run(_, decode.int))
  |> result.flatten
}

pub fn get_boolean_value(
  opts options: Dict(String, Dynamic),
  name name: String,
) {
  dict.get(options, name)
  |> result.replace_error([])
  |> result.map(decode.run(_, decode.bool))
  |> result.flatten
}

pub fn get_user_value(
  opts options: Dict(String, Dynamic),
  res resolved: Dynamic,
  name name: String,
) {
  use user_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )

  let users =
    decode.run(resolved, decode.at(["users", user_id], decode.dynamic))
  let members =
    decode.run(resolved, decode.at(["members", user_id], decode.dynamic))

  Ok(#(users, members))
}

pub fn get_channel_value(
  opts options: Dict(String, Dynamic),
  res resolved: Dynamic,
  name name: String,
) {
  use channel_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )

  decode.run(resolved, decode.at(["channels", channel_id], decode.dynamic))
}

pub fn get_role_value(
  opts options: Dict(String, Dynamic),
  res resolved: Dynamic,
  name name: String,
) {
  use role_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )

  decode.run(resolved, decode.at(["channels", role_id], decode.dynamic))
}

pub fn get_mention_value(
  opts options: Dict(String, Dynamic),
  res resolved: Dynamic,
  name name: String,
) {
  use mention_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )

  let role =
    decode.run(resolved, decode.at(["roles", mention_id], decode.dynamic))
    |> option.from_result
  let users =
    decode.run(resolved, decode.at(["users", mention_id], decode.dynamic))
    |> option.from_result
  let members =
    decode.run(resolved, decode.at(["members", mention_id], decode.dynamic))
    |> option.from_result

  Ok(#(role, users, members))
}

pub fn get_number_value(
  opts options: Dict(String, Dynamic),
  name name: String,
) {
  dict.get(options, name)
  |> result.replace_error([])
  |> result.map(decode.run(_, decode.float))
  |> result.flatten
}

pub fn get_attachment_value(
  opts options: Dict(String, Dynamic),
  res resolved: Dynamic,
  name name: String,
) {
  use attachment_id <- result.try(
    dict.get(options, name)
    |> result.replace_error([])
    |> result.map(decode.run(_, decode.string))
    |> result.flatten,
  )

  decode.run(
    resolved,
    decode.at(["attachments", attachment_id], decode.dynamic),
  )
}
