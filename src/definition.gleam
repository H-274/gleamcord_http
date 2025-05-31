import handler

pub opaque type Command {
  MessageCommand(
    name: String,
    locales: List(#(String, String)),
    handler: handler.Command,
  )
  UserCommand(
    name: String,
    locales: List(#(String, String)),
    handler: handler.Command,
  )
  TextCommand(TextCommand)
}

pub fn message_command(
  name name: String,
  locales locales: List(#(String, String)),
  handler handler: handler.Command,
) {
  MessageCommand(name:, locales:, handler:)
}

pub fn user_command(
  name name: String,
  locales locales: List(#(String, String)),
  handler handler: handler.Command,
) {
  UserCommand(name:, locales:, handler:)
}

pub type TextCommand {
  Command(
    name: String,
    // TODO
    params: List(Nil),
    name_locales: List(#(String, String)),
    description: String,
    desc_locales: List(#(String, String)),
    handler: handler.Command,
  )
  CommandGroup(
    name: String,
    name_locales: List(#(String, String)),
    sub_commands: List(SubCommand),
  )
}

pub fn text_command(
  name name: String,
  // TODO
  params params: List(Nil),
  name_locales name_locales: List(#(String, String)),
  desc description: String,
  desc_locales desc_locales: List(#(String, String)),
  handler handler: handler.Command,
) {
  Command(name:, params:, name_locales:, description:, desc_locales:, handler:)
  |> TextCommand
}

pub fn command_group(
  name name: String,
  name_locales name_locales: List(#(String, String)),
  sub_commands sub_commands: List(SubCommand),
) {
  CommandGroup(name:, name_locales:, sub_commands:)
  |> TextCommand
}

pub type SubCommand {
  SubCommand(
    name: String,
    params: List(Nil),
    name_locales: List(#(String, String)),
    description: String,
    desc_locales: List(#(String, String)),
    handler: handler.Command,
  )
  SubCommandGroup(
    name: String,
    name_locales: List(#(String, String)),
    sub_commands: List(SubCommand),
  )
}

pub fn sub_command(
  name name: String,
  params params: List(Nil),
  name_locales name_locales: List(#(String, String)),
  desc description: String,
  desc_locales desc_locales: List(#(String, String)),
  handler handler: handler.Command,
) {
  SubCommand(
    name:,
    params:,
    name_locales:,
    description:,
    desc_locales:,
    handler:,
  )
}

pub fn sub_command_group(
  name name: String,
  name_locales name_locales: List(#(String, String)),
  sub_commands sub_commands: List(SubCommand),
) {
  SubCommandGroup(name:, name_locales:, sub_commands:)
}

pub type Component
