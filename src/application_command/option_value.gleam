import gleam/dict.{type Dict}
import gleam/dynamic/decode

pub type OptionValue {
  Values(Values)
  Group(Group)
}

pub fn command_option_decoder() -> decode.Decoder(OptionValue) {
  decode.one_of(
    decode.list(value_decoder() |> decode.map(fn(o) { #(o.name, o) }))
      |> decode.map(dict.from_list)
      |> decode.map(Values),
    [decode.at([0], group_decoder()) |> decode.map(Group)],
  )
}

pub type Values =
  Dict(String, Value)

pub type Value {
  StringValue(name: String, value: String, focused: Bool)
  IntegerValue(name: String, value: Int, focused: Bool)
  BooleanValue(name: String, value: Bool, focused: Bool)
  UserValue(name: String, value: Int, focused: Bool)
  ChannelValue(name: String, value: Int, focused: Bool)
  RoleValue(name: String, value: Int, focused: Bool)
  MentionableValue(name: String, value: Int, focused: Bool)
  NumberValue(name: String, value: Float, focused: Bool)
  AttachmentValue(name: String, value: Int, focused: Bool)
}

pub fn value_decoder() -> decode.Decoder(Value) {
  use variant <- decode.field("type", decode.int)
  case variant {
    3 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.string)
      use focused <- decode.field("focused", decode.bool)
      decode.success(StringValue(name:, value:, focused:))
    }
    4 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.int)
      use focused <- decode.field("focused", decode.bool)
      decode.success(IntegerValue(name:, value:, focused:))
    }
    5 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.bool)
      use focused <- decode.field("focused", decode.bool)
      decode.success(BooleanValue(name:, value:, focused:))
    }
    6 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.int)
      use focused <- decode.field("focused", decode.bool)
      decode.success(UserValue(name:, value:, focused:))
    }
    7 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.int)
      use focused <- decode.field("focused", decode.bool)
      decode.success(ChannelValue(name:, value:, focused:))
    }
    8 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.int)
      use focused <- decode.field("focused", decode.bool)
      decode.success(RoleValue(name:, value:, focused:))
    }
    9 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.int)
      use focused <- decode.field("focused", decode.bool)
      decode.success(MentionableValue(name:, value:, focused:))
    }
    10 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.float)
      use focused <- decode.field("focused", decode.bool)
      decode.success(NumberValue(name:, value:, focused:))
    }
    11 -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.int)
      use focused <- decode.field("focused", decode.bool)
      decode.success(AttachmentValue(name:, value:, focused:))
    }
    _ ->
      decode.failure(StringValue(name: "", value: "", focused: False), "Value")
  }
}

pub type Group {
  SubcommandGroup(SubcommandGroup)
  Subcommand(Subcommand)
}

pub fn group_decoder() -> decode.Decoder(Group) {
  use variant <- decode.field("type", decode.int)
  case variant {
    1 -> subcommand_decoder() |> decode.map(Subcommand)
    2 -> subcommand_group_decoder() |> decode.map(SubcommandGroup)
    _ -> decode.failure(Subcommand(SubcommandValue("", dict.new())), "Group")
  }
}

pub type SubcommandGroup {
  SubcommandGroupValue(name: String, sub: Subcommand)
}

pub fn subcommand_group_decoder() -> decode.Decoder(SubcommandGroup) {
  use name <- decode.field("name", decode.string)
  use sub <- decode.field("options", subcommand_decoder())

  decode.success(SubcommandGroupValue(name:, sub:))
}

pub type Subcommand {
  SubcommandValue(name: String, options: Values)
}

pub fn subcommand_decoder() -> decode.Decoder(Subcommand) {
  use name <- decode.field("name", decode.string)
  use options <- decode.field(
    "options",
    decode.list(value_decoder() |> decode.map(fn(o) { #(o.name, o) })),
  )

  let options = dict.from_list(options)

  decode.success(SubcommandValue(name:, options:))
}
