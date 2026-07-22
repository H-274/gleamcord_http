import gleam/dict.{type Dict}
import gleam/dynamic/decode.{type Decoder}
import gleam/list

pub type CommandOption {
  Group(Group)
  Values(Dict(String, Value))
}

pub fn decoder() {
  use t <- decode.field(0, decode.at(["type"], decode.int))
  case t {
    1 ->
      decode.at([0], subcommand_decoder())
      |> decode.map(SubcommandElement)
      |> decode.map(Group)
    2 -> decode.at([0], group_element_decoder()) |> decode.map(Group)
    _ ->
      decode.list(value_decoder() |> decode.map(fn(v) { #(v.name, v) }))
      |> decode.map(dict.from_list)
      |> decode.map(Values)
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

pub fn find_focused(values: List(Value)) {
  use v <- list.find(values)
  case v {
    StringValue(focused:, ..) -> focused
    IntegerValue(focused:, ..) -> focused
    NumberValue(focused:, ..) -> focused
    _ -> False
  }
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
  use focused <- decode.optional_field("focused", False, decode.bool)

  StringValue(name:, value:, focused:)
  |> decode.success
}

fn integer_value_decoder() -> Decoder(Value) {
  use name <- decode.field("name", decode.string)
  use value <- decode.field("value", decode.int)
  use focused <- decode.optional_field("focused", False, decode.bool)

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
  use focused <- decode.optional_field("focused", False, decode.bool)

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
  GroupElement(name: String, subcommand: Subcommand)
}

fn group_element_decoder() -> Decoder(Group) {
  use name <- decode.field("name", decode.string)
  use subcommand <- decode.subfield(["options", "0"], subcommand_decoder())

  GroupElement(name:, subcommand:)
  |> decode.success
}

pub type Subcommand {
  Subcommand(name: String, options: Dict(String, Value))
}

fn subcommand_decoder() -> Decoder(Subcommand) {
  use name <- decode.field("name", decode.string)
  use options <- decode.optional_field(
    "options",
    [],
    decode.list(value_decoder()),
  )
  let options = options |> list.map(fn(o) { #(o.name, o) }) |> dict.from_list

  Subcommand(name:, options:)
  |> decode.success
}
