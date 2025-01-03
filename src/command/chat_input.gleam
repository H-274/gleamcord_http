import command/command_option.{type CommandOption}
import command/handler
import gleam/list
import locale.{type Locale}

pub opaque type Command(ctx) {
  Command(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    sub_or_options: SubCommandTreeOrHandler(ctx),
    default_member_permissions: String,
    integration_types: List(Int),
    contexts: List(Int),
    nsfw: Bool,
  )
}

pub fn new_command(name name: String, desc description: String) {
  Command(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    sub_or_options: RootHandler([], handler.chat_input_undefined),
    default_member_permissions: "",
    integration_types: [],
    contexts: [],
    nsfw: False,
  )
}

pub fn command_locales(
  definition: Command(ctx),
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(item) { #(item.0, item.1) })
  let description_locales = list.map(locales, fn(item) { #(item.0, item.2) })

  Command(..definition, name_locales:, description_locales:)
}

pub fn command_integration_types(
  definition: Command(ctx),
  integration_types: List(Int),
) {
  Command(..definition, integration_types:)
}

pub fn command_contexts(definition: Command(ctx), contexts: List(Int)) {
  Command(..definition, contexts:)
}

pub fn command_nsfw(definition: Command(ctx)) {
  Command(..definition, nsfw: True)
}

pub fn command_handler(
  definition: Command(ctx),
  options: List(command_option.Definition(ctx)),
  handler: handler.ChatInputHandler(ctx, CommandOption),
) {
  Command(..definition, sub_or_options: RootHandler(options, handler))
}

pub fn command_sub_commands(
  definition: Command(ctx),
  subs: List(SubCommandTree(ctx)),
) {
  Command(..definition, sub_or_options: SubCommandTree(subs))
}

pub opaque type SubCommandTreeOrHandler(ctx) {
  SubCommandTree(List(SubCommandTree(ctx)))
  RootHandler(
    List(command_option.Definition(ctx)),
    handler: handler.ChatInputHandler(ctx, CommandOption),
  )
}

pub opaque type SubCommandTree(ctx) {
  SubCommandGroupNode(SubCommandGroup(ctx))
  SubCommandNode(SubCommand(ctx))
}

pub opaque type SubCommandGroup(ctx) {
  SubCommandGroup(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    sub_commands: List(SubCommandTree(ctx)),
  )
}

pub fn new_sub_command_group(name name: String, desc description: String) {
  SubCommandGroup(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    sub_commands: [],
  )
}

pub fn sub_command_group_locales(
  sub_group: SubCommandGroup(ctx),
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(item) { #(item.0, item.1) })
  let description_locales = list.map(locales, fn(item) { #(item.0, item.2) })

  SubCommandGroup(..sub_group, name_locales:, description_locales:)
}

pub fn sub_command_group_sub_trees(
  sub_group: SubCommandGroup(ctx),
  sub_commands: List(SubCommandTree(ctx)),
) {
  SubCommandGroupNode(SubCommandGroup(..sub_group, sub_commands:))
}

pub opaque type SubCommand(ctx) {
  SubCommand(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    options: List(command_option.CommandOption),
    handler: handler.ChatInputHandler(ctx, CommandOption),
  )
}

pub fn new_sub_command(name name: String, desc description: String) {
  SubCommand(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    options: [],
    handler: handler.chat_input_undefined,
  )
}

pub fn sub_command_locales(
  sub: SubCommand(ctx),
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(item) { #(item.0, item.1) })
  let description_locales = list.map(locales, fn(item) { #(item.0, item.2) })

  SubCommand(..sub, name_locales:, description_locales:)
}

pub fn sub_command_handler(
  sub: SubCommand(ctx),
  options: List(command_option.CommandOption),
  handler: handler.ChatInputHandler(ctx, CommandOption),
) {
  SubCommandNode(SubCommand(..sub, options:, handler:))
}
