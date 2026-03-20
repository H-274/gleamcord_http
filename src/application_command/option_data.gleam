import gleam/dynamic/decode
import internal/type_utils

pub type Options =
  type_utils.Or(CommandOptions, CommandGroupOptions)

pub fn options_decoder() -> decode.Decoder(Options) {
  decode.one_of(decode.list(value_decoder()) |> decode.map(type_utils.A), [
    decode.list(
      decode.one_of(subcommand_group_decoder() |> decode.map(type_utils.A), [
        subcommand_decoder() |> decode.map(type_utils.B),
      ]),
    )
    |> decode.map(type_utils.B),
  ])
}

pub type CommandOptions =
  List(Value)

pub type CommandGroupOptions =
  List(type_utils.Or(SubcommandGroup, Subcommand))

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

pub type SubcommandGroup {
  SubcommandGroup(name: String, subcommands: List(Subcommand))
}

pub fn subcommand_group_decoder() -> decode.Decoder(SubcommandGroup) {
  use name <- decode.field("name", decode.string)
  use subcommands <- decode.field(
    "subcommands",
    decode.list(todo as "Decoder for Subcommand"),
  )
  decode.success(SubcommandGroup(name:, subcommands:))
}

pub type Subcommand {
  Subcommand(name: String, options: List(Value))
}

pub fn subcommand_decoder() -> decode.Decoder(Subcommand) {
  use name <- decode.field("name", decode.string)
  use options <- decode.field(
    "options",
    decode.list(todo as "Decoder for Value"),
  )
  decode.success(Subcommand(name:, options:))
}
