import gleam/dict.{type Dict}

pub type OptionValue {
  Group(Group)
  Value(Value)
}

pub fn decoder() {
  todo
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
  Attachment(name: String, value: String)
}

pub type Group {
  GroupElement(name: String, subcommands: Dict(String, Subcommand))
  SubcommandElement(Subcommand)
}

pub type Subcommand {
  Subcommand(name: String, options: Dict(String, Value))
}
