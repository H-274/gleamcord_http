import gleam/dict.{type Dict}
import gleam/dynamic/decode.{type Decoder}
import gleam/list

pub type OptionValue {
  Group(Group)
  Value(Value)
}

pub fn decoder() {
  use t <- decode.field("type", decode.int)
  case t {
    1 ->
      subcommand_decoder()
      |> decode.map(SubcommandElement)
      |> decode.map(Group)
    2 -> group_element_decoder() |> decode.map(Group)
    _ -> value_decoder() |> decode.map(Value)
  }
}

pub type Value {
  StringValue(name: String, value: String, focused: Bool)
  IntegerValue(name: String, value: Int, focused: Bool)
  BooleanValue(name: String, value: Bool)
  UserValue(name: String, value: String)
  ChannelValue(name: String, value: String)
  RoleValue(name: String, value: String)
  MentionableValue(name: String, value: String)
  NumberValue(name: String, value: Float, focused: Bool)
  AttachmentValue(name: String, value: String)
}

fn value_decoder() -> Decoder(Value) {
  use t <- decode.field("type", decode.int)
  case t {
    3 -> string_value_decoder()
    4 -> integer_value_decoder()
    5 -> boolean_value_decoder()
    6 -> user_value_decoder()
    7 -> channel_value_decoder()
    8 -> role_value_decoder()
    9 -> mentionable_value_decoder()
    10 -> number_value_decoder()
    11 -> attachment_value_decoder()
    _ -> decode.failure(StringValue("", "", False), "Value")
  }
}

fn string_value_decoder() -> Decoder(Value) {
  use name <- decode.field("name", decode.string)
  use value <- decode.field("value", decode.string)
  use focused <- decode.field("focused", decode.bool)

  StringValue(name:, value:, focused:)
  |> decode.success
}

fn integer_value_decoder() -> Decoder(Value) {
  use name <- decode.field("name", decode.string)
  use value <- decode.field("value", decode.int)
  use focused <- decode.field("focused", decode.bool)

  IntegerValue(name:, value:, focused:)
  |> decode.success
}

fn boolean_value_decoder() -> Decoder(Value) {
  use name <- decode.field("name", decode.string)
  use value <- decode.field("value", decode.bool)

  BooleanValue(name:, value:)
  |> decode.success
}

fn user_value_decoder() -> Decoder(Value) {
  use name <- decode.field("name", decode.string)
  use value <- decode.field("value", decode.string)

  UserValue(name:, value:)
  |> decode.success
}

fn channel_value_decoder() -> Decoder(Value) {
  use name <- decode.field("name", decode.string)
  use value <- decode.field("value", decode.string)

  ChannelValue(name:, value:)
  |> decode.success
}

fn role_value_decoder() -> Decoder(Value) {
  use name <- decode.field("name", decode.string)
  use value <- decode.field("value", decode.string)

  RoleValue(name:, value:)
  |> decode.success
}

fn mentionable_value_decoder() -> Decoder(Value) {
  use name <- decode.field("name", decode.string)
  use value <- decode.field("value", decode.string)

  MentionableValue(name:, value:)
  |> decode.success
}

fn number_value_decoder() -> Decoder(Value) {
  use name <- decode.field("name", decode.string)
  use value <- decode.field("value", decode.float)
  use focused <- decode.field("focused", decode.bool)

  NumberValue(name:, value:, focused:)
  |> decode.success
}

fn attachment_value_decoder() -> Decoder(Value) {
  use name <- decode.field("name", decode.string)
  use value <- decode.field("value", decode.string)

  AttachmentValue(name:, value:)
  |> decode.success
}

pub type Group {
  SubcommandElement(Subcommand)
  GroupElement(name: String, subcommands: Dict(String, Subcommand))
}

fn group_element_decoder() -> Decoder(Group) {
  use name <- decode.field("name", decode.string)
  use subcommands <- decode.field("options", decode.list(subcommand_decoder()))
  let subcommands =
    subcommands |> list.map(fn(s) { #(s.name, s) }) |> dict.from_list

  GroupElement(name:, subcommands:)
  |> decode.success
}

pub type Subcommand {
  Subcommand(name: String, options: Dict(String, Value))
}

fn subcommand_decoder() -> Decoder(Subcommand) {
  use name <- decode.field("name", decode.string)
  use options <- decode.field("options", decode.list(value_decoder()))
  let options = options |> list.map(fn(o) { #(o.name, o) }) |> dict.from_list

  Subcommand(name:, options:)
  |> decode.success
}
